#!/bin/bash - 
#===============================================================================
#
#          FILE: pre-provision.sh
# 
#         USAGE: ./pre-provision.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Kevin Faulkner (), 
#  ORGANIZATION: 
#       CREATED: 01/13/19 14:13
#      REVISION:  ---
#===============================================================================
set -ex

FILE=${1}
MIRROR_LIST="http://www.gtlib.gatech.edu/pub/gentoo http://mirrors.evowise.com/gentoo/ http://gentoo.c3sl.ufpr.br/ http://gentoo.mirrors.ovh.net/gentoo-distfiles/ http://ftp.swin.edu.au/gentoo"
#SELECTED_MIRROR=$(awk '/iso_url/{ gsub("[\",]"," ", $2); match($2,/[\/]releases/); mirror=substr($2,0,RSTART-1); print mirror}' ${FILE})
FALLBACK_MIRROR="http://distfiles.gentoo.org/"
DRIVE_TYPE=$(awk '/(disk|hard_drive)_interface/{ gsub("[\",]"," ", $2); print $2}' ${FILE})
MIRROR_PATH="/releases/amd64/autobuilds/"
BUILD_TYPE="stage3-amd64-nomultilib"

if [[ -z $SELECTED_MIRROR ]]; then
  time=9999
  for mirror in ${MIRROR_LIST}[@]; do
    measured_time=$(curl -s -w "%{time_connect}" ${mirror}{STAGE_PATH}/latest-stage3.txt -o /dev/null)
	measured_time=$(echo "${measured_time}"|sed 's/\.//g')
	#%{speed_download} would be nice but getting an accurate rate would mean dowloading a large amount of data
	awk -v time=$time measured_time=$measured_time '{print meausred_time > time }' 
	if [[ $measured_time -lt $time ]]; then
	  SELECTED_MIRROR=${mirror}
    fi
  done
  if [[ -z $SELECTED_MIRROR ]]; then
    SELECTED_MIRROR=$FALLBACK_MIRROR
  fi
fi
ISO=$(curl ${mirror}{MIRROR_PATH}/latest-iso.txt | awk '/install-amd64-minimal/{print $1}')
ISO_SHA512=$(curl ${mirror}{MIRROR_PATH}/${latest_iso}.DIGESTS | awk '/SHA512/{getline; print $1 ; exit}')


STAGE3=$(curl ${mirror}{MIRROR_PATH}/latest-stage3-amd64-nomultilib.txt |awk -F/ '/stage3-amd64/{ print $1 }' )

if [[ $DRIVE_TYPE ~= virtio ]]; then
  DISK=vda
else
  DISK=sda
fi
export DISK
export SELECTED_MIRROR
export STAGE3
export ISO_SHA512


