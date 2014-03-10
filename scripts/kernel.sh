#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
emerge sys-kernel/gentoo-sources
cd /usr/src/linux
make defconfig
make -j2
make modules_install
cp arch/x86_64/boot/bzImage /boot/kernel
cp System.map /boot/System.map
EOF
