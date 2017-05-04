#!/bin/sh
set -e
source $(dirname "$0")/variables.sh
if btrfs subvolume show ${ROOT_SNAPSHOT} ; then
  if btrfs subvolume show ${LAST_PARENT} ; then
    btrfs subvolume delete ${LAST_PARENT}
  fi
  if btrfs subvolume show ${CURRENT_PARENT} ; then
    mv ${CURRENT_PARENT} ${LAST_PARENT}
  fi
  if btrfs subvolume show ${CURRENT_STATE} ; then
    mv ${CURRENT_STATE} ${CURRENT_PARENT}
  fi
  btrfs subvolume snapshot -r ${DATA_VOLUME} ${CURRENT_STATE}
else
  btrfs subvolume snapshot -r ${DATA_VOLUME} ${ROOT_SNAPSHOT}
fi
