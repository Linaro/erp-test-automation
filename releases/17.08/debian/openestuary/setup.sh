#!/bin/sh
set -e
set -x

VERSION=403
TFTP_PATH=${HOME}/tftp/debian-installer/${VERSION}

mkdir -p ${TFTP_PATH}
if [ ! -f ${TFTP_PATH}/initrd.gz ]; then
	#wget -o ${TFTP_PATH}/initrd.gz http://releases.linaro.org/reference-platform/enterprise/${VERSION}/debian-installer/debian-installer/arm64/initrd.gz
	curl -L -o ${TFTP_PATH}/initrd.gz http://builds.96boards.org/snapshots/reference-platform/components/debian-installer-staging/${VERSION}/debian-installer/arm64/initrd.gz
fi
if [ ! -f ${TFTP_PATH}/linux ]; then
	#wget -o ${TFTP_PATH}/linux http://releases.linaro.org/reference-platform/enterprise/${VERSION}/debian-installer/debian-installer/arm64/linux
	curl -L -o ${TFTP_PATH}/linux http://builds.96boards.org/snapshots/reference-platform/components/debian-installer-staging/${VERSION}/debian-installer/arm64/linux
fi
if [ -f ${HOME}/grub.cfg ]; then
    mv ${HOME}/grub.cfg ${HOME}/.grub.cfg.$(date +%s)
fi
sed "s/USERNAME/${USER}/g; s/VERSION/${VERSION}/g" grub.cfg > ${HOME}/grub.cfg
