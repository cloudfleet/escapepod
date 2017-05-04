#!/bin/sh
set -e
source $(dirname "$0")/variables.sh
if btrfs subvolume show ${ROOT_SNAPSHOT} ; then
  btrfs subvolume delete ${ROOT_SNAPSHOT}
fi
if btrfs subvolume show ${LAST_PARENT} ; then
  btrfs subvolume delete ${LAST_PARENT}
fi
if btrfs subvolume show ${CURRENT_PARENT} ; then
  btrfs subvolume delete ${CURRENT_PARENT}
fi
if btrfs subvolume show ${CURRENT_STATE} ; then
  btrfs subvolume delete ${CURRENT_STATE}
fi
