#!/bin/sh
if [ $1 ]; then
  STORAGE_DRIVER=$1
fi

SNAPSHOTS_DIR=${DATA_VOLUME}/.snapshots/${STORAGE_DRIVER}

ROOT_SNAPSHOT=${SNAPSHOTS_DIR}/root
LAST_PARENT=${SNAPSHOTS_DIR}/last_parent
CURRENT_PARENT=${SNAPSHOTS_DIR}/current_parent
CURRENT_STATE=${SNAPSHOTS_DIR}/current_state

function snapshot_exists() {
  btrfs subvolume show $1 > /dev/null 2>&1
}

function clear_snapshot() {
  if snapshot_exists $1 ; then
    btrfs subvolume delete $1
  fi
}
