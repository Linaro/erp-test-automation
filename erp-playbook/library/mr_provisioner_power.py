#!/usr/bin/python

import json
import requests
import time
from datetime import datetime, timedelta

from future.standard_library import install_aliases
install_aliases()

from urllib.parse import urljoin  # nopep8
from urllib import quote  # nopep8

ANSIBLE_METADATA = {
    'metadata_version': '1.1',
    'status': ['preview'],
    'supported_by': 'community'
}

DOCUMENTATION = '''
---
module: mr-provisioner-power

short_description: Wait for power on/off.

description:
    - Wait for power on/off.
    - Suppot to force power on/off when timeout reached.

options:
    machine_name:
        description: Machine name
        required: true
    url:
        description: url to provisioner instance in the form of http://172.27.80.1:5000/
        required: true
    token:
        description: Mr. Provisioner auth token
        required: true
    wait_for_power:
        description: Desired power state
        required: true
        choices:
            - on: wait for system power on
            - off: wait for system power off
    timeout:
        description: Maximum number of seconds before interrupt request.
        required: false
        default: 21600
    sleep:
        description:  Number of seconds to sleep between checks.
        required: false
        default: 300
    force_power:
        description: Force power to the state defined in wait_for_power.
        required: false
        choices: ['true', 'false']
        default: false

author:
    - Dan Rue <dan.rue@linaro.org>
    - Chase Qi <chase.qi@linaro.org>
'''

EXAMPLES = '''
# Wait until machine is powered off.
- name: Wait for power off
delegate_to: localhost
mr_provisioner_power:
  machine_name: "{{ inventory_hostname }}"
  url: "{{ mr_provisioner_url }}"
  token: "{{ mr_provisioner_auth_token }}"
  wait_for_power: off
  timeout: 3600
  sleep: 300
  force_power: true
register: result
- debug: var=result
'''

RETURN = '''

'''

from ansible.module_utils.basic import AnsibleModule  # nopep8


class ProvisionerError(Exception):
    def __init__(self, message):
        super(ProvisionerError, self).__init__(message)


def get_machine_by_name(url, token, machine_name):
    """ Look up machine by name """
    headers = {'Authorization': token}
    q = '(= name "{}")'.format(quote(machine_name))
    url = urljoin(url, "/api/v1/machine?q={}&show_all=false".format(q))
    r = requests.get(url, headers=headers)
    if r.status_code != 200:
        raise ProvisionerError('Error fetching {}, HTTP {} {}'.format(url, r.status_code, r.reason))
    if len(r.json()) == 0:
        raise ProvisionerError('Error no assigned machine found with name "{}"'.format(machine_name))
    if len(r.json()) > 1:
        raise ProvisionerError('Error more than one machine found with name "{}", {}'.format(machine_name, r.json()))
    return r.json()[0]


def get_power_state(url, token, machine_id):
    """ Look up power state by machine ID """
    headers = {'Authorization': token}
    url = urljoin(url, "/api/v1/machine/{}/power".format(machine_id))
    r = requests.get(url, headers=headers)
    if r.status_code != 200:
        raise ProvisionerError('Error posting {}, HTTP {} {}'.format(url, r.status_code, r.reason))
    return r.json()


def change_power_state(url, token, machine_id, state):
    """ Change power state by machine ID """
    headers = {'Authorization': token}
    url = urljoin(url, "/api/v1/machine/{}/power".format(machine_id))
    data = json.dumps({'state': state})
    r = requests.post(url, headers=headers, data=data)
    if r.status_code not in [200, 202]:
        raise ProvisionerError('Error posting {}, HTTP {} {}'.format(url, r.status_code, r.reason))


def run_module():
    module_args = dict(
        machine_name=dict(type='str', required=True),
        url=dict(type='str', required=True),
        token=dict(type='str', required=True),
        wait_for_power=dict(type='str', choices=['on', 'off'], required=True),
        timeout=dict(type='int', default=21600),
        sleep=dict(type='int', default=300),
        force_power=dict(type='bool', default=False),
    )

    result = dict(
        changed=False,
        debug={},
        power_state={},
        force_powered=False,
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    if module.check_mode:
        return result

    # Look up machine, verify assignment
    try:
        machine = get_machine_by_name(module.params['url'],
                                      module.params['token'],
                                      module.params['machine_name'])
    except ProvisionerError as e:
        module.fail_json(msg=str(e), **result)
    result['debug']['machine'] = machine

    # Wait for power on/off state with timeout.
    max_end_time = datetime.utcnow() + timedelta(seconds=module.params['timeout'])
    while datetime.utcnow() < max_end_time:
        try:
            power_state = get_power_state(module.params['url'],
                                          module.params['token'],
                                          machine_id=machine['id'])

        except ProvisionerError as e:
            module.fail_json(msg=str(e), **result)

        if power_state['state'] == module.params['wait_for_power']:
            result['power_state'] = power_state
            module.exit_json(**result)
        else:
            time.sleep(module.params['sleep'])

    if module.params['force_power']:
        try:
            change_power_state(module.params['url'],
                               module.params['token'],
                               machine_id=machine['id'],
                               state=module.params['wait_for_power'])
        except ProvisionerError as e:
            module.fail_json(msg=str(e), **result)

        # Check if power state changed correctly.
        for i in range(12):
            time.sleep(5)
            try:
                power_state = get_power_state(module.params['url'],
                                              module.params['token'],
                                              machine_id=machine['id'])
            except ProvisionerError as e:
                module.fail_json(msg=str(e), **result)

            if power_state['state'] == module.params['wait_for_power']:
                result['changed'] = True
                result['force_powered'] = True
                result['power_state'] = power_state
                module.exit_json(**result)
        result['power_state'] = power_state
        module.fail_json(msg='Failed to force power {} after 60 seconds.'
                         .format(module.params['wait_for_power']), **result)
    else:
        result['power_state'] = power_state
        module.fail_json(msg='Wait for power {} timed out after {} seconds.'
                         .format(module.params['wait_for_power'], module.params['timeout']), **result)


def main():
    run_module()

if __name__ == '__main__':
    main()
