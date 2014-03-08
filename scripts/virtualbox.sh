#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
emerge "=virtual/linux-sources-1" --autounmask-write
etc-update --automode -5
emerge "=virtual/linux-sources-1"

emerge ">=app-emulation/virtualbox-guest-additions-4.3" --autounmask-write
etc-update --automode -5
emerge ">=app-emulation/virtualbox-guest-additions-4.3"

rc-update add virtualbox-guest-additions default
EOF
