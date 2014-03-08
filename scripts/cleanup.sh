#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
rm -rf /usr/portage
rm -rf /tmp/*
rm -rf /var/log/*
rm -rf /var/tmp/*
eclean -d distfiles
EOF
