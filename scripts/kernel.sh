#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
emerge sys-kernel/gentoo-sources
emerge sys-kernel/genkernel
cd /usr/src/linux
make defconfig
genkernel --install --symlink --oldconfig all
EOF
