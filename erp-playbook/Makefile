get-last-change:
	sh local_scripts/check-for-changes.sh

provision-drue:
	ansible-playbook -K -t provision -l erp-drue main.yml
run-drue:
	ansible-playbook -t run_test -l erp-drue main.yml
