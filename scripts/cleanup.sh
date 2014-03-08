#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
cd /usr/src/linux && make clean
emerge -C sys-kernel/gentoo-sources
emerge sys-fs/zerofree --autounmask-write
etc-update --automode -5
emerge sys-fs/zerofree
rm -rf /usr/portage
rm -rf /tmp/*
rm -rf /var/log/*
rm -rf /var/tmp/*
EOF

mount -o remount,ro /mnt/gentoo

chroot /mnt/gentoo /bin/bash <<'EOF'
zerofree /dev/sda4
swapoff /dev/sda3
dd if=/dev/zero of=/dev/sda3
mkswap /dev/sda3
EOF
