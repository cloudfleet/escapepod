#!/bin/sh
set -e
source $(dirname "$0")/variables.sh
mkdir -p ${SNAPSHOTS_DIR}
if snapshot_exists ${ROOT_SNAPSHOT} ; then
  clear_snapshot ${LAST_PARENT}
  if snapshot_exists ${CURRENT_PARENT} ; then
    mv ${CURRENT_PARENT} ${LAST_PARENT}
  fi
  if snapshot_exists ${CURRENT_STATE} ; then
    mv ${CURRENT_STATE} ${CURRENT_PARENT}
  fi
  btrfs subvolume snapshot -r ${DATA_VOLUME} ${CURRENT_STATE}
else
  btrfs subvolume snapshot -r ${DATA_VOLUME} ${ROOT_SNAPSHOT}
fi
