ERP Get Build
=============

Download an Enterprise Reference Platform (ERP) release.

By default, this role will discover the latest staging ERP build from jenkins,
set 'erp_latest_build' number, and download the build to ./builds/staging/.

Requirements
------------

None

Role Variables
--------------

In:

| variable | description | default
|----------|-------------|---------
| erp_debian_installer_environment | [staging|release] | staging

Out:

| variable | description | example
|----------|-------------|---------
| erp_latest_build | Latest build number, based on debian_installer_environment | 430

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
        - role: get_erp_build

License
-------

BSD

Author Information
------------------

Dan Rue <dan.rue@linaro.org>
