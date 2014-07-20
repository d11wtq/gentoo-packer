#!/bin/bash

tarball=stage3-amd64-nomultilib-$STAGE3.tar.bz2

mount /dev/sda4 /mnt/gentoo

cd /mnt/gentoo
wget http://distfiles.gentoo.org/releases/amd64/autobuilds/$STAGE3/$tarball
tar xvjpf $tarball
rm -f $tarball
