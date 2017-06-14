#!/bin/bash

report_url="https://staging-qa-reports.linaro.org"
plans="plans/rpb_ee/rpb_ee_functional.yaml plans/rpb_ee/rpb_ee_performance.yaml plans/rpb_ee/rpb_ee_enterprise.yaml plans/rpb_ee/rpb_ee_stress.yaml"

root_path=/root
td_path=${root_path}/test-definitions

cd ${td_path}
. ./automated/bin/setenv.sh
datetime=$(date +%s)

for plan in ${plans}; do
    plan_short=$(basename -s .yaml ${plan})
    output_path=${root_path}/${plan_short}-${datetime}
    mkdir -p ${output_path}
    test-runner -o ${output_path} \
                -p ${plan} \
                > ${output_path}/test-runner-stdout.log \
                2> ${output_path}/test-runner-stderr.log
    post-to-squad -r ${output_path}/result.json \
                  -b ${datetime} \
                  -a ${output_path}/result.csv \
                  -a ${output_path}/test-runner-stdout.log \
                  -a ${output_path}/test-runner-stderr.log \
                  -u ${report_url} -t erp \
                  > ${output_path}/post-to-squad.log 2>&1
done
