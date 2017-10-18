BUILD_NUM = # retrieve latest build by default
BUILD_ENV = staging # alternately, use stable

provision-drue: roles
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -K -t provision -l erp-drue -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
else
	ansible-playbook -K -t provision -l erp-drue -e erp_build_number=$(BUILD_NUM) -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
endif

run-drue: roles
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -t run_test -l erp-drue -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
else
	ansible-playbook -t run_test -l erp-drue -e "{erp_build_number: $(BUILD_NUM)}" -e erp_debian_installer_environment=$(BUILD_ENV) main.yml
endif

roles:
	ansible-galaxy install -p roles -r requirements.yml

clean:
	rm -rf roles
