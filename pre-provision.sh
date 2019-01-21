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

FILE=${1}
MIRROR_LIST="http://www.gtlib.gatech.edu/pub/gentoo http://mirrors.evowise.com/gentoo http://gentoo.c3sl.ufpr.br http://gentoo.mirrors.ovh.net/gentoo-distfiles http://ftp.swin.edu.au/gentoo"
DETECTED_MIRROR=$(awk '/iso_url/{ gsub("[\",]"," ", $2); match($2,/[\/]releases/); mirror=substr($2,0,RSTART-1); print mirror}' ${FILE})
FALLBACK_MIRROR="http://distfiles.gentoo.org"
DRIVE_TYPE=$(awk '/(disk|hard_drive)_interface/{ gsub("[\",]"," ", $2); print $2}' ${FILE})
MIRROR_PATH="/releases/amd64/autobuilds"
BUILD_TYPE="stage3-amd64-nomultilib"

if [[ -z $DETECTED_MIRROR ]]; then
  time=0
  for mirror in ${MIRROR_LIST}; do
    measured_time=$(curl -s -w "%{time_connect}" ${mirror}${MIRROR_PATH}/latest-stage3.txt -o /dev/null)
    #%{speed_download} would be nice but getting an accurate rate would mean dowloading a large amount of data
    compare=$(awk -v time=$time -v measured_time=$measured_time 'BEGIN{print(meausred_time < time?1:0) }' )
    if [[ $compare -eq 0 ]]; then
      time=$measured_time
      export SELECTED_MIRROR=${mirror}${MIRROR_PATH}
    fi
  done
fi
if [[ -z $SELECTED_MIRROR ]]; then
  export SELECTED_MIRROR=$FALLBACK_MIRROR${MIRROR_PATH}
elif [[ ! -z $DETECTED_MIRROR ]]; then
  printf "no support yet"
fi
export ISO="/$(curl ${SELECTED_MIRROR}/latest-iso.txt | awk '/install-amd64-minimal/{print $1}')"
export ISO_SHA512=$(curl ${SELECTED_MIRROR}${ISO}.DIGESTS | awk '/SHA512/{getline; print $1 ; exit}')


export STAGE3=$(curl ${SELECTED_MIRROR}/latest-stage3-amd64-nomultilib.txt |awk -F/ '/stage3-amd64/{ print $1 }' )

if [[ $DRIVE_TYPE =~ virtio ]]; then
  export DISK=vda
else
  export DISK=sda
fi

