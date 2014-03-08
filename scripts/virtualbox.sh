#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
emerge app-emulation/virtualbox-guest-additions --autounmask-write
etc-update --automode -5
emerge app-emulation/virtualbox-guest-additions
rc-update add virtualbox-guest-additions default
EOF
