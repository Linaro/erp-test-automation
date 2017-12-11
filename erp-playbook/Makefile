BUILD_NUM = # retrieve latest build by default
BUILD_ENV = staging # alternately, use stable

provision-and-run-drue: roles
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -l erp-drue -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
else
	ansible-playbook -l erp-drue -e erp_build_number=$(BUILD_NUM) -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
endif

provision-drue: roles
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -t provision -l erp-drue -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
else
	ansible-playbook -t provision -l erp-drue -e erp_build_number=$(BUILD_NUM) -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
endif

run-drue: roles
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -t run_test -l erp-drue -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
else
	ansible-playbook -t run_test -l erp-drue -e "{erp_build_number: $(BUILD_NUM)}" -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
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
