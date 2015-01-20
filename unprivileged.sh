#!/bin/sh

set -ex

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

# qemu-system-arm -machine vexpress-a9 -m 512 -nographic -kernel /usr/share/u-boot.git/arm/vexpress-a9/u-boot -sd Fedora-Minimal-armhfp-21-5-sda.raw
