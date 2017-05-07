#!/bin/sh
set -e
source $(dirname "$0")/variables.sh

function move_snapshot() {
  if snapshot_exists $1 ; then
    btrfs property set -ts $1 ro false
    mv $1 ${DATA_VOLUME}/
  fi
}

function set_readonly() {
  if snapshot_exists $1 ; then
    btrfs property set -ts $1 ro true
  fi
}

if snapshot_exists ${CURRENT_RESTORE_STATE} ; then
  btrfs subvolume snapshot ${CURRENT_RESTORE_STATE} ${DATA_VOLUME}
else
  btrfs subvolume snapshot ${ROOT_RESTORE_SNAPSHOT} ${DATA_VOLUME}
fi

move_snapshot $ROOT_RESTORE_SNAPSHOT
move_snapshot $LAST_RESTORE_PARENT
move_snapshot $CURRENT_RESTORE_PARENT
move_snapshot $CURRENT_RESTORE_STATE

set_readonly $ROOT_SNAPSHOT
set_readonly $LAST_PARENT
set_readonly $CURRENT_PARENT
set_readonly $CURRENT_STATE

btrfs subvolume delete $RESTORE_TMP_DIR
