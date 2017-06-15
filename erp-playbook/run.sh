#!/bin/sh

if [ -z $1 ] || [ -z $2 ]; then
    echo "Usage: $0 <build_number> <hostname>"
    echo "Run erp tests with a given build_number against a given hostname"
    echo "hostname must be defined in hosts."
    exit 1
fi

ansible-playbook -i hosts main.yml -e build_number=${1} --limit ${2}
