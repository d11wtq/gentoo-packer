#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
touch /etc/udev/rules.d/80-net-name-slot.rules
ln -s /etc/init.d/net.lo /etc/init.d/net.eth0
rc-update add net.eth0 default
EOF
