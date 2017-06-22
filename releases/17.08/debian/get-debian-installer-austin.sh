#!/bin/sh
set -e
set -x

VERSION=$1

if [ -z ${VERSION} ]; then
    echo "Usage: $0 <debian-installer staging build number>"
    echo "See http://builds.96boards.org/snapshots/reference-platform/components/debian-installer-staging/"
    exit 1
fi

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

TFTP_PATH=/var/lib/tftpboot/debian-staging/${VERSION}

mkdir -p ${TFTP_PATH}
if [ ! -f ${TFTP_PATH}/initrd.gz ]; then
    curl -L -o ${TFTP_PATH}/initrd.gz http://builds.96boards.org/snapshots/reference-platform/components/debian-installer-staging/${VERSION}/debian-installer/arm64/initrd.gz
fi
if [ ! -f ${TFTP_PATH}/linux ]; then
    curl -L -o ${TFTP_PATH}/linux http://builds.96boards.org/snapshots/reference-platform/components/debian-installer-staging/${VERSION}/debian-installer/arm64/linux
fi

cp /var/lib/tftpboot/grub.cfg /var/lib/tftpboot/.grub.cfg.$(date +%s)
cat << EOF >> /var/lib/tftpboot/grub.cfg
menuentry 'Install Debian Jessie - RP Staging - Image $VERSION - Automated' {
    linux /debian-staging/$VERSION/linux auto=true interface=auto priority=critical noshell BOOT_DEBUG=1 DEBIAN_FRONTEND=text url=http://people.linaro.org/~dan.rue/erp-test-automation/releases/17.08/debian/preseed.cfg ---
    initrd /debian-staging/$VERSION/initrd.gz
}

EOF

