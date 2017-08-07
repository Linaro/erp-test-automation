#!/bin/sh

BUILD_ENV=$1

if [ "${BUILD_ENV}" != "staging" -a "${BUILD_ENV}" != "stable" ]; then
    echo "Usage: $0 [staging|stable]"
    exit 1
fi

if [ "${BUILD_ENV}" = "staging" ]; then
    URLs=$(cat <<EOF
        http://repo.linaro.org/debian/erp-17.08-stable/dists/jessie/main/binary-arm64/Packages.bz2
        http://repo.linaro.org/debian/erp-17.08-staging/dists/jessie/main/binary-arm64/Packages.bz2
        http://repo.linaro.org/debian/erp-17.08-staging/dists/jessie/main/debian-installer/binary-arm64/Packages.gz
EOF
    )
elif [ "${BUILD_ENV}" = "stable" ]; then
    URLs=$(cat <<EOF
        http://repo.linaro.org/debian/erp-17.08-stable/dists/jessie/main/binary-arm64/Packages.bz2
        http://repo.linaro.org/debian/erp-17.08-stable/dists/jessie/main/debian-installer/binary-arm64/Packages.gz
EOF
    )
else
    echo "ERROR: Unknown value ${BUILD_ENV}"
    exit 1
fi

RESULT=""
for url in $URLs; do

    LAST_CHANGE="$(curl --silent -I ${url} | grep ^Last-Modified | sed 's/Last-Modified: //')"
    # Convert to a sortable datetime
    LAST_CHANGE=$(date -d "${LAST_CHANGE}" --iso-8601=seconds --utc)

    if [ -n "${RESULT}" ]; then
        RESULT="${RESULT}"$'\n'
    fi
    RESULT="${RESULT}${LAST_CHANGE}"

done

#echo "${RESULT}"
#echo ""
echo "Last Change: $(echo "${RESULT}" | sort -n | tail -1)"

