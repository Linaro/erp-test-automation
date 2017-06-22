#!/bin/sh
set -e
set -x

VERSION=$1

if [ -z ${VERSION} ]; then
	echo "Usage: $0 <debian-installer staging build number>"
	echo "See http://builds.96boards.org/snapshots/reference-platform/components/debian-installer-staging/"
	exit 1
fi

DOWNLOAD_PATH=$HOME/debian-staging/${VERSION}

mkdir -p ${DOWNLOAD_PATH}
if [ ! -f ${DOWNLOAD_PATH}/initrd.gz ]; then
    curl -L -o ${DOWNLOAD_PATH}/initrd.gz http://builds.96boards.org/snapshots/reference-platform/components/debian-installer-staging/${VERSION}/debian-installer/arm64/initrd.gz
fi
if [ ! -f ${DOWNLOAD_PATH}/linux ]; then
    curl -L -o ${DOWNLOAD_PATH}/linux http://builds.96boards.org/snapshots/reference-platform/components/debian-installer-staging/${VERSION}/debian-installer/arm64/linux
fi
