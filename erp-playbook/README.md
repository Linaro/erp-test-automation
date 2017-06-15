ERP Test Harness
================

This ansible playbook can be used to automate the ERP testing on a set of given
hosts.

Usage
-----

First, you will need a vault password. Ask the Linaro QA team, and then store
it in '~/.vault_pass_erp.txt'.

Modify hosts in 'hosts' file. Run `run.sh <build_number> <hostname>`.

Ansible will ssh into the given host, install test-definitions prerequisites,
clone test-definitions, run each test plan that is used for ERP testing, and
post the results to https://qa-reports.linaro.org/ using the given build
number.

The ansible run is idempotent; each time it is run, if the tests are already
running on a host it will not do anything. If the tests are not running on a
host, it will start them.

Note that 'hosts' and 'group_vars/all' files are encrypted using ansible vault.
To use, the vault password will have to be available in ~/.vault_pass_erp.txt.
Once set, use `ansible-vault edit` to view and modify.
