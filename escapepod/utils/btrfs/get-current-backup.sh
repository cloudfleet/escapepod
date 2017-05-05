#!/bin/sh
set -e
source $(dirname "$0")/variables.sh
if snapshot_exists ${CURRENT_STATE} ; then
  if snapshot_exists ${CURRENT_PARENT} ; then
    btrfs send -p ${CURRENT_PARENT} ${CURRENT_STATE}
  else
    btrfs send -p ${ROOT_SNAPSHOT} ${CURRENT_STATE}
  fi
else
  btrfs send ${ROOT_SNAPSHOT}
fi
