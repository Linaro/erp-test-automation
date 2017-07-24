BUILD_NUM = # retrieve latest build by default

get-last-change:
	sh local_scripts/check-for-changes.sh

provision-drue:
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -K -t provision -l erp-drue main.yml
else
	ansible-playbook -K -t provision -l erp-drue -e erp_build_number=$(BUILD_NUM) main.yml
endif

run-drue:
ifeq ($(strip $(BUILD_NUM)),)
	ansible-playbook -t run_test -l erp-drue main.yml
else
	ansible-playbook -t run_test -l erp-drue -e "{erp_build_number: $(BUILD_NUM)}" main.yml
endif

roles:
	ansible-galaxy install -p roles -r requirements.yml

clean:
	rm -rf roles
