# Gentoo - Minimal Vagrant Box

This is the most minimal stage3 installation of Gentoo (amd64, nomultilib) that
is possible to package into a Vagrant box file.

It is based on the official
[Quick Install](https://www.gentoo.org/doc/en/gentoo-x86-quickinstall.xml)
guide, but avoids completing any of the optional steps.

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

**Do not** run `emerge --search` before you do this, because you will add
unnecessary strain on the portage mirror and may even get yourself banned by
the mirror.

## What's installed?

Short answer, nothing that's not in the stage3 + genkernel + grub2 +
gentoo-sources.

In reality, the following things are also installed for Vagrant to work:

  - app-emulation/virtualbox-guest-additions
  - net-fs/nfs-utils
  - app-admin/sudo

## What's configured?

Everything is left as the defaults. The time zone is set to UTC.

### No vixie-cron? No syslog? No chef? Huh?

When I say _"most minimal stage3 installation"_, I mean minimal. If you want
these things, you are free to install them yourself using Vagrant's built-in
provisioning system. That's exactly why this project was created. I was unable
to find a truly faithful stage3 install for Vagrant.
