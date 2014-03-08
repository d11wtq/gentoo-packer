#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
ln -s /etc/init.d/net.lo /etc/init.d/net.eth0
echo 'config_eth0=( "dhcp" )' >> /etc/conf.d/net
rc-update add net.eth0 default
EOF
