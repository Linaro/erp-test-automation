#!/bin/sh

if [ -z $1 ]; then
    echo "Usage: $0 <build_number>"
    exit 1
fi

report_url="{{erp_squad_url[erp_squad_environment]}}"
plans="plans/rpb_ee/rpb_ee_functional.yaml plans/rpb_ee/rpb_ee_enterprise.yaml plans/rpb_ee/rpb_ee_performance.yaml plans/rpb_ee/rpb_ee_ltp.yaml"

root_path=/root
td_path=${root_path}/test-definitions

# Gather environmental info for erp project and environment names
vendor_name=$(slugify `cat /sys/devices/virtual/dmi/id/board_vendor`)
board_name=$(slugify `cat /sys/devices/virtual/dmi/id/board_name`)
os_name=$(slugify `grep ^ID= /etc/os-release | awk -F= '{print $2}'`)

cd ${td_path}
. ./automated/bin/setenv.sh
build_id=$1-$(dpkg-query -W -f '${package}-${version}\n' | grep linaro | md5sum | cut -c -8)

for plan in ${plans}; do
    plan_short=$(basename -s .yaml ${plan})
    output_path=${root_path}/${build_id}-${plan_short}
    mkdir -p ${output_path}
    test-runner -o ${output_path} \
                -p ${plan} \
                > ${output_path}/test-runner-stdout.log \
                2> ${output_path}/test-runner-stderr.log
    post-to-squad -r ${output_path}/result.json \
                  -b ${build_id} \
                  -a ${output_path}/result.csv \
                  -a ${output_path}/test-runner-stdout.log \
                  -a ${output_path}/test-runner-stderr.log \
                  -u ${report_url} \
                  -t erp-${vendor_name} \
                  -p staging-debian \
                  > ${output_path}/post-to-squad.log 2>&1
done
