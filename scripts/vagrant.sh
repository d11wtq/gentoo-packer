#!/bin/bash

chroot /mnt/gentoo /bin/bash <<'EOF'
USE="-sendmail" emerge app-admin/sudo
emerge net-fs/nfs-utils
useradd -m -s /bin/bash vagrant
echo vagrant:vagrant | chpasswd
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant
mkdir -p ~vagrant/.ssh
wget https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub \
  -O ~vagrant/.ssh/authorized_keys
chmod 0700 ~vagrant/.ssh
chmod 0600 ~vagrant/.ssh/authorized_keys
chown -R vagrant: ~vagrant/.ssh
rc-update add sshd default
EOF
