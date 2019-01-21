#!/bin/bash

tarball=stage3-amd64-nomultilib-$STAGE3.tar.xz
if [[ ! -z ${MIRROR} ]]; then
  URL=${MIRROR}
else
  URL=http://distfiles.gentoo.org/releases/amd64/autobuilds/
fi
mount /dev/${DISK}4 /mnt/gentoo

cd /mnt/gentoo
curl -s -O ${URL}${STAGE3}/${tarball}
tar xpf $tarball
rm -f $tarball
