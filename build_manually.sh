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
  path="./scripts/$script.sh"
  echo "Start $path"
  ("$path")
  echo "Finished $path"
done

echo "All done, shutting down in"
for s in 5 4 3 2 1
do
  echo -n " $s"
done

shutdown -hP now
