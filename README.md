# Gentoo - Minimal Vagrant Box

This is the most minimal stage3 installation of Gentoo (amd64, nomultilib) that
is possible to package into a Vagrant box file.

It is based on the official
[Quick Install](https://www.gentoo.org/doc/en/gentoo-x86-quickinstall.xml)
guide, but avoids completing any of the optional steps.

## Box URL

> https://dl.dropboxusercontent.com/s/lyombjyb8f96ksh/gentoo-amd64-stage3.box

(**262MB**, Updated as new stage3 tarballs are published)

## Usage

This is a [Packer](https://packer.io/) template. Install the latest version of
Packer, then:

    packer build gentoo.json

This will chew for a bit and finally output a Vagrant box file.

## On your first boot

Because keeping the portage tree in the image would be costly in terms of file
size, and because it gets out of date quickly, it is not present in the image.
Perform an initial `emerge-webrsync` to generate the portage tree.

    emerge-webrsync

**Do not** run `emerge --sync` before you do this, because you will add
unnecessary strain on the portage mirror and may even get yourself banned by
the mirror.

## Disk size

The disk is a 60GB sparse disk. You do not need 60GB of free space initially.
The disk will grow as disk usage increases.

## What's installed?

Short answer, nothing that's not in the stage3 + grub + gentoo-sources.

In reality, the following things are also installed for Vagrant to work:

  - app-emulation/virtualbox-guest-additions
  - net-fs/nfs-utils
  - app-admin/sudo

## What's configured?

Everything is left as the defaults. The time zone is set to UTC.
