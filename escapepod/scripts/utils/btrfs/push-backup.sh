#!/bin/sh
set -e
source $(dirname "$0")/variables.sh
if snapshot_exists ${RESTORE_TMP_DIR} ; then
  echo ""
else
  btrfs subvolume create ${RESTORE_TMP_DIR}
fi

clear_snapshot ${LAST_RESTORE_PARENT}
if snapshot_exists ${CURRENT_RESTORE_PARENT} ; then
  mv ${CURRENT_RESTORE_PARENT} ${LAST_RESTORE_PARENT}
fi
if snapshot_exists ${CURRENT_RESTORE_STATE} ; then
  mv ${CURRENT_RESTORE_STATE} ${CURRENT_RESTORE_PARENT}
fi

btrfs receive ${RESTORE_TMP_DIR}
