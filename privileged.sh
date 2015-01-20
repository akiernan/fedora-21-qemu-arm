#!/bin/sh

set -ex

yum -y install deltarpm
yum -y install kernel-devel kernel-headers gcc
yum -y update
yum -y install xz qemu-system-arm libguestfs-tools
(cd /etc/yum.repos.d && curl -L -O https://www.kraxel.org/repos/firmware.repo)
yum -y install u-boot.git-arm
yum -y install virt-install libvirt-daemon-config-network
systemctl start libvirtd.service

cd /var/lib/libvirt/images
curl -L -O http://download.fedoraproject.org/pub/fedora/linux/releases/21/Images/armhfp/Fedora-Minimal-armhfp-21-5-sda.raw.xz
unxz Fedora-Minimal-armhfp-21-5-sda.raw.xz
guestfish -x <<EOF
add Fedora-Minimal-armhfp-21-5-sda.raw
run
mount /dev/sda3 /
download /etc/shadow /tmp/shadow
! sed 's/^root:[^:]\+:/root::/' /tmp/shadow > /tmp/shadow.new
upload /tmp/shadow.new /etc/shadow
rm /etc/systemd/system/multi-user.target.wants/initial-setup-text.service
umount /
EOF

virt-install --name f21-arm-a9-uboot --ram 512 --arch armv7l --machine vexpress-a9 --os-variant fedora21 --boot kernel=/usr/share/u-boot.git/arm/vexpress-a9/u-boot --disk /var/lib/libvirt/images/Fedora-Minimal-armhfp-21-5-sda.raw --import --print-xml >/tmp/f21-arm-a9-uboot.xml
virsh define /tmp/f21-arm-a9-uboot.xml
virsh start f21-arm-a9-uboot
