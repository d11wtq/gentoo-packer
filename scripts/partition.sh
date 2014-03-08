#!/bin/bash

sgdisk \
  -n 1:0:+128M -t 1:8300 -c 1:"linux-boot" \
  -n 2:0:+32M  -t 2:ef02 -c 2:"bios-boot"  \
  -n 3:0:+1G   -t 3:8200 -c 3:"swap"       \
  -n 4:0:0     -t 4:8300 -c 4:"linux-root" \
  -p /dev/sda

sync

mkfs.ext2 /dev/sda1
mkfs.ext4 /dev/sda4

mkswap /dev/sda3 && swapon /dev/sda3
