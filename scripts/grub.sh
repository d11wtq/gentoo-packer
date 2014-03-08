#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
emerge '>=sys-boot/grub-2.0'
grub2-mkconfig -o /boot/grub/grub.cfg
grub2-install /dev/sda
EOF
