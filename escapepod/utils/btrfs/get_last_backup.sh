#!/bin/sh
set -e
source $(dirname "$0")/variables.sh
if btrfs subvolume show ${CURRENT_PARENT} ; then
  if btrfs subvolume show ${LAST_PARENT} ; then
    btrfs send -p ${LAST_PARENT} ${CURRENT_PARENT}
  else
    btrfs send -p ${ROOT_SNAPSHOT} ${CURRENT_PARENT}
  fi
fi
