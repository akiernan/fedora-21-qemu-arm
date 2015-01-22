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
curl --progress-bar -L -O http://download.fedoraproject.org/pub/fedora/linux/releases/21/Images/armhfp/Fedora-Minimal-armhfp-21-5-sda.raw.xz
unxz Fedora-Minimal-armhfp-21-5-sda.raw.xz
guestfish -x <<'EOF'
add Fedora-Minimal-armhfp-21-5-sda.raw
run
mount /dev/sda3 /
mount /dev/sda1 /boot
download /etc/shadow /tmp/shadow
! sed -i -e 's/^root:[^:]\+:/root::/' /tmp/shadow
upload /tmp/shadow /etc/shadow
rm /etc/systemd/system/multi-user.target.wants/initial-setup-text.service
download /boot/extlinux/extlinux.conf /tmp/extlinux.conf
! sed -i -e '/^ui /d; /^menu /d; /^totaltimeout /d' /tmp/extlinux.conf
! echo "ONTIMEOUT `grubby -c /tmp/extlinux.conf --extlinux --default-title`" >> /tmp/extlinux.conf
upload /tmp/extlinux.conf /boot/extlinux/extlinux.conf
ln-sf ../usr/share/zoneinfo/UTC /etc/localtime
umount /boot
umount /
EOF

virt-install --name f21-arm-a9-uboot --ram 512 --arch armv7l --machine vexpress-a9 --os-variant fedora21 --boot kernel=/usr/share/u-boot.git/arm/vexpress-a9/u-boot --disk /var/lib/libvirt/images/Fedora-Minimal-armhfp-21-5-sda.raw --import --print-xml >/tmp/f21-arm-a9-uboot.xml
virsh define /tmp/f21-arm-a9-uboot.xml
virsh autostart f21-arm-a9-uboot
virsh start f21-arm-a9-uboot
