BUILD_NUM = # retrieve latest build by default
BUILD_ENV = staging # alternately, use stable

provision-and-run-cb-g0: roles
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -l cb-g0 -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
else
	ansible-playbook -l cb-g0 -e erp_build_number=$(BUILD_NUM) -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
endif

provision-cb-g0: roles
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -t provision -l cb-g0 -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
else
	ansible-playbook -t provision -l cb-g0 -e erp_build_number=$(BUILD_NUM) -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
endif

run-cb-g0: roles
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -t run_test -l cb-g0 -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
else
	ansible-playbook -t run_test -l cb-g0 -e "{erp_build_number: $(BUILD_NUM)}" -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
endif

provision-and-run-chase: roles
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -l chase_erp -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
else
	ansible-playbook -l chase_erp -e erp_build_number=$(BUILD_NUM) -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
endif

provision-chase: roles
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -t provision -l chase_erp -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
else
	ansible-playbook -t provision -l chase_erp -e erp_build_number=$(BUILD_NUM) -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
endif

run-chase: roles
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -t run_test -l chase_erp -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
else
	ansible-playbook -t run_test -l chase_erp -e "{erp_build_number: $(BUILD_NUM)}" -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
endif

roles:
	ansible-galaxy install -p roles -r requirements.yml

clean:
	rm -rf roles
