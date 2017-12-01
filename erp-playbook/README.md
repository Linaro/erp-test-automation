# ERP Test Harness

This ansible playbook can be used to automate the ERP testing on a set of given
hosts.

## Roles

ERP testing is as easy as 1 2 3:
1. Get a build
2. Load a build on a host (provision)
3. Install prerequisites on a host and run the tests autonomously

The ansible run is idempotent; each time it is run, if the tests are already
running on a host it will not do anything. If the tests are not running on a
host, it will start them.

### Find ERP build

The `Linaro.erp-get-build` role will download the latest (or specified) build
locally. This role is required to be run before the subsequent roles.

### Provision Host

The `Linaro.mr-provisioner` role is used to provision hosts in the UK
Cambridge lab, or any lab that uses mr-provisioner..

### Run ERP Test Suite

The `Linaro.erp-run-test-suite` role will ssh into the given host, install
test-definitions prerequisites, clone test-definitions, run each test plan that
is used for ERP testing, and post the results to https://qa-reports.linaro.org/
using the given latest build number (discovered or specified in
`Linaro.erp-get-build`).

## Usage

See the `Makefile` for example usecases.

Note that 'hosts' and 'group_vars/' files are encrypted using ansible vault.
To use, the vault password will have to be available in ~/.vault_pass_erp.txt.
Once set, use `ansible-vault edit` to view and modify.

See `hosts.dist` and `group_vars/erp_all.dist` for examples of inventory
definitions.

To run against a given host or host group, run `ansible-playbook -l
<hostname|hostgroup> main.yml`. If -l (limit) is not used, ansible will attempt
to run against every host defined in `hosts`.

## Examples

Provision and run tests on hosts in the 'erp-drue' hostgroup:

    make provision-and-run-drue

Provision hosts and run tests separately. Set build number explicitly:

    make provision-drue BUILD_NUM=450
    make run-drue BUILD_NUM=450

Provision and run against hosts using the stable build number 321:

    make provision-drue BUILD_ENV=staging BUILD_NUM=321
    make run-drue BUILD_ENV=staging BUILD_NUM=321
