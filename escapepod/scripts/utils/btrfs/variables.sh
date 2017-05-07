#!/bin/sh
if [ $1 ]; then
  STORAGE_DRIVER=$1
fi

SNAPSHOTS_DIR=${DATA_VOLUME}/.snapshots/${STORAGE_DRIVER}

RESTORE_TMP_DIR=${DATA_VOLUME}_TMP_RESTORE

ROOT_SNAPSHOT=${SNAPSHOTS_DIR}/root
LAST_PARENT=${SNAPSHOTS_DIR}/last_parent
CURRENT_PARENT=${SNAPSHOTS_DIR}/current_parent
CURRENT_STATE=${SNAPSHOTS_DIR}/current_state

ROOT_RESTORE_SNAPSHOT=${RESTORE_TMP_DIR}/root
LAST_RESTORE_PARENT=${RESTORE_TMP_DIR}/last_parent
CURRENT_RESTORE_PARENT=${RESTORE_TMP_DIR}/current_parent
CURRENT_RESTORE_STATE=${RESTORE_TMP_DIR}/current_state


function snapshot_exists() {
  btrfs subvolume show $1 > /dev/null 2>&1
}

function clear_snapshot() {
  if snapshot_exists $1 ; then
    btrfs subvolume delete $1
  fi
}
