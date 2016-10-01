#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
sed -i 's/^#\s*GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="net.ifnames=0"/' \
  /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
ln -s /etc/init.d/net.lo /etc/init.d/net.eth0
echo 'config_eth0=( "dhcp" )' >> /etc/conf.d/net
rc-update add net.eth0 default
EOF
