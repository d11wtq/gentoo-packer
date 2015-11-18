#!/bin/bash
# Asumption ATLUS PACKER is doing Automatic builds with 0 human's at the helm 
# should the first Of the machines DNS FAIL or not match new end users machine on boot /DHCP less fuss.
cat >>/mnt/gentoo/etc/resolv.conf <<EOF
nameserver 8.8.8.8  #Google Primary Public DNS
nameserver 8.8.4.4  #Google Secoundary Public DNS
nameserver 2001:4860:4860::8888 #Google Primary Public DNS IPV6
nameserver 2001:4860:4860::8844 #Google Secoundary Public DNS IPV6
EOF
