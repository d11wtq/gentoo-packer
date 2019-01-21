#!/bin/bash
chroot /mnt/gentoo /bin/bash <<'EOF'
cat > /etc/fstab <<'DATA'
# <fs>		<mount>	<type>	<opts>		<dump/pass>
/dev/${DISK}1	/boot	ext4	noauto,noatime	1 2
/dev/${DISK}4	/	xfs		noatime		0 1
/dev/${DISK}3	none	swap	sw		0 0
DATA
EOF
