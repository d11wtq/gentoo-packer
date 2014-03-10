#!/bin/bash

if [[ -z $STAGE3 ]]
then
  echo "STAGE3 environment variable must be set to a timestamp."
  exit 1
fi

for script in \
  partition   \
  stage3      \
  mounts      \
  portage     \
  timezone    \
  fstab       \
  kernel      \
  grub        \
  virtualbox  \
  network     \
  vagrant     \
  cleanup
do
  "./scripts/$script.sh"
done

echo "All done."
