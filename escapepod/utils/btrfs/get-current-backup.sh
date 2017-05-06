#!/bin/sh
set -e
source $(dirname "$0")/variables.sh
if snapshot_exists ${CURRENT_STATE} ; then
  if snapshot_exists ${CURRENT_PARENT} ; then
    btrfs send -p ${CURRENT_PARENT} ${CURRENT_STATE}
  else
    btrfs send -p ${ROOT_SNAPSHOT} ${CURRENT_STATE}
  fi
elif snapshot_exists ${ROOT_SNAPSHOT}; then
  btrfs send ${ROOT_SNAPSHOT}
else
  echo "no-local-backup"
fi
