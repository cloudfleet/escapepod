#!/bin/sh
ENCRYPTION_METHOD=none

if [ $2 ]; then
  STORAGE_DRIVER=$2
fi
export STORAGE_DRIVER

function do_backup() {
  if check_last_backup; then
    echo "Found backup to work from"
  else
    echo "No backup found. Starting with full backup"
    reset_backup
  fi
  utils/btrfs/take_snapshot.sh
}

function check_last_backup() {
  return 1
}

function reset_backup() {
  utils/btrfs/clear_snapshots.sh
}



function load_encryption_key() {
  echo "Doing nothing for now"
}

if [ "$1" == 'backup' ]; then
  echo "doing backup"
  do_backup
elif [ "$1" == 'restore' ]; then
  echo "doing restore"
else
  echo "use 'escape.sh backup' or 'escape.sh restore'"
fi
