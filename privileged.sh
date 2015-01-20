#!/bin/sh

set -ex

yum -y install deltarpm
yum -y update
yum -y install pulseaudio xz qemu-system-arm libguestfs-tools
yum -y install kernel-devel kernel-headers gcc
(cd /etc/yum.repos.d && curl -L -O https://www.kraxel.org/repos/firmware.repo)
yum -y install u-boot.git-arm
