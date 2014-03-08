#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
cat > /etc/fstab <<'DATA'
# <fs>		<mount>	<type>	<opts>		<dump/pass>
/dev/sda1	/boot	ext2	noauto,noatime	1 2
/dev/sda4	/	ext4	noatime		0 1
/dev/sda3	none	swap	sw		0 0
DATA
EOF
