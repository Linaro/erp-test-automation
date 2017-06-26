#!/bin/sh
set -e
set -x

VERSION=$1

if [ -z ${VERSION} ]; then
    echo "Usage: $0 <debian-installer staging build number>"
    echo "See http://builds.96boards.org/snapshots/reference-platform/components/debian-installer-staging/"
    exit 1
fi

TFTP_PATH=${HOME}/tftp/debian-staging/${VERSION}

mkdir -p ${TFTP_PATH}
if [ ! -f ${TFTP_PATH}/initrd.gz ]; then
	curl -f -L -o ${TFTP_PATH}/initrd.gz http://builds.96boards.org/snapshots/reference-platform/components/debian-installer-staging/${VERSION}/debian-installer/arm64/initrd.gz
fi
if [ ! -f ${TFTP_PATH}/linux ]; then
	curl -f -L -o ${TFTP_PATH}/linux http://builds.96boards.org/snapshots/reference-platform/components/debian-installer-staging/${VERSION}/debian-installer/arm64/linux
fi
if [ -f ${HOME}/grub.cfg ]; then
    mv ${HOME}/grub.cfg ${HOME}/.grub.cfg.$(date +%s)
fi


#    linux  /$USERNAME/debian-installer/$VERSION/linux \
#        pcie_aspm=off \
#        acpi=force \
#        console=ttyS0,115200 \
#        earlycon=hisilpcuart,mmio,0xa01b0000,0,0x2f8 \
#        auto=true \
#        priority=critical
#        #url=http://people.linaro.org/~dan.rue/erp-1708/preseed.cfg ---
#    initrd /$USERNAME/debian-installer/$VERSION/initrd.gz

cat << EOF > ${HOME}/grub.cfg
menuentry 'debian-erp-${VERSION}-installer' --id debian-erp-${VERSION}-installer {
    linux /${USER}/debian-staging/${VERSION}/linux \
        pcie_aspm=off \
        acpi=force \
        console=ttyS0,115200 \
        earlycon=hisilpcuart,mmio,0xa01b0000,0,0x2f8 \
        auto=true \
        priority=critical \
        url=http://people.linaro.org/~dan.rue/erp-test-automation/releases/17.08/debian/preseed.cfg ---
    initrd /${USER}/debian-staging/${VERSION}/initrd.gz
}
EOF
