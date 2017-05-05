#!/bin/sh
set -e
source $(dirname "$0")/variables.sh
if snapshot_exists ${CURRENT_PARENT} ; then
  if snapshot_exists ${LAST_PARENT} ; then
    btrfs send -p ${LAST_PARENT} ${CURRENT_PARENT}
  else
    btrfs send -p ${ROOT_SNAPSHOT} ${CURRENT_PARENT}
  fi
else
  if snapshot_exists ${ROOT_SNAPSHOT} ; then
    btrfs send ${ROOT_SNAPSHOT}
  fi
fi
