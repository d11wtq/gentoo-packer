#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
emerge ">=sys-boot/grub-2.0"
sed -i 's/^#\s*GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="net.ifnames=0"/' \
  /etc/default/grub
echo "set timeout=0" >> /etc/grub.d/40_custom
grub2-install /dev/sda
grub2-mkconfig -o /boot/grub/grub.cfg
EOF
