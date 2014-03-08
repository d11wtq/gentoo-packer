#!/bin/bash

mount /dev/sda4 /mnt/gentoo
mkdir /mnt/gentoo/boot
mount /dev/sda1 /mnt/gentoo/boot

cd /mnt/gentoo

wget http://distfiles.gentoo.org/releases/amd64/autobuilds/$STAGE3/stage3-amd64-nomultilib-$STAGE3.tar.bz2
tar xjpf stage3-amd64-nomultilib-$STAGE3.tar.bz2
rm stage3-amd64-nomultilib-$STAGE3.tar.bz2
