#!/bin/sh
OLD_DIR=${PWD}
cd $(dirname "$0")

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
  utils/btrfs/take-snapshot.sh
  METADATA_FILE=$(utils/metadata/create_current_backup_metadata.sh)

  cat ${METADATA_FILE} \
    | ./utils/encryption/${ENCRYPTION_METHOD}/encrypt.sh \
    | ./storage/${STORAGE_DRIVER}/store-backup-metadata.sh

  ./utils/btrfs/get-current-backup.sh \
    | ./utils/encryption/${ENCRYPTION_METHOD}/encrypt.sh \
    | ./storage/${STORAGE_DRIVER}/store-backup.sh $(cat ${METADATA_FILE} | jq -r .hash)
}

function check_last_backup() {
  REMOTE_LAST_BACKUP_METADATA=$(./storage/${STORAGE_DRIVER}/get-backup-metadata.sh \
    | ./utils/encryption/${ENCRYPTION_METHOD}/decrypt.sh)
  LOCAL_LAST_BACKUP_METADATA=$(./utils/metadata/get-backup-metadata.sh)
  REMOTE_LAST_BACKU
}

function reset_backup() {
  utils/btrfs/clear-snapshots.sh
  utils/metadata/clear-metadata.sh
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

cd ${OLD_DIR}
