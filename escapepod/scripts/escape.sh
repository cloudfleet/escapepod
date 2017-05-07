#!/bin/sh
set -e
OLD_DIR=${PWD}
cd $(dirname "$0")

ENCRYPTION_METHOD=none

if [ $2 ]; then
  STORAGE_DRIVER=$2
fi
export STORAGE_DRIVER
export ENCRYPTION_METHOD

function do_restore() {
  if utils/btrfs/data-volume-exists.sh; then
    echo "Data volume exists. Will not overwrite it."
    return 1
  fi

  ./utils/restore/recursive-restore.sh

  ./utils/btrfs/recreate-tree.sh

}


function do_backup() {
  if check_last_backup; then
    LOCAL_LAST_BACKUP_UUID=$(./utils/metadata/get-backup-metadata.sh | jq -r .uuid)
    echo "Found backup to work from (UUID: ${LOCAL_LAST_BACKUP_UUID})"
  else
    echo "No backup found. Starting with full backup"
    reset_backup
  fi
  echo "Taking snapshot..."
  utils/btrfs/take-snapshot.sh
  echo "Creating metadata"
  METADATA_FILE=$(utils/metadata/create-current-backup-metadata.sh ${LOCAL_LAST_BACKUP_UUID})

  echo "Created metadata for backup with id $(cat ${METADATA_FILE} | jq -r .uuid)"

  cat ${METADATA_FILE} | encrypt \
    | ./storage/${STORAGE_DRIVER}/store-backup-metadata.sh $(cat ${METADATA_FILE} | jq -r .uuid)

  ./utils/btrfs/get-current-backup.sh | encrypt \
    | ./storage/${STORAGE_DRIVER}/store-backup.sh $(cat ${METADATA_FILE} | jq -r .hash)
}

function check_last_backup() {
  echo "Verifying last backup ..."
  echo "Verifying metadata..."
  REMOTE_LAST_BACKUP_METADATA=$(./storage/${STORAGE_DRIVER}/get-backup-metadata.sh \
    | ./utils/encryption/${ENCRYPTION_METHOD}/decrypt.sh) \
    | jq -c .
  LOCAL_LAST_BACKUP_METADATA=$(./utils/metadata/get-backup-metadata.sh) \
    | jq -c .

  if [ "$REMOTE_LAST_BACKUP_METADATA" == "$LOCAL_LAST_BACKUP_METADATA" ]; then

    echo "Verified metadata."
    echo "Verifying data stream..."

    LOCAL_LAST_BACKUP_HASH=$(./utils/btrfs/get-current-backup.sh | sha512sum | awk '{print $(1)}')
    REMOTE_LAST_BACKUP_HASH=$(./storage/${STORAGE_DRIVER}/get-backup.sh ${LOCAL_LAST_BACKUP_HASH} | decrypt | sha512sum | awk '{print $(1)}')

    if [ "$LOCAL_LAST_BACKUP_HASH" == "$REMOTE_LAST_BACKUP_HASH" ]; then
      echo "Verified data stream."
      echo "Last remote backup verified!"
    else
      echo "===================="
      echo "Mismatched hashes!"
      echo "===================="
      echo "Local"
      echo "--------------------"
      echo $LOCAL_LAST_BACKUP_HASH
      echo "--------------------"
      echo "Remote"
      echo "--------------------"
      echo $REMOTE_LAST_BACKUP_HASH
      echo "===================="
      return 1
    fi
  else
    echo "===================="
    echo "Mismatched metadata!"
    echo "===================="
    echo "Local"
    echo "--------------------"
    echo $LOCAL_LAST_BACKUP_METADATA
    echo "--------------------"
    echo "Remote"
    echo "--------------------"
    echo $REMOTE_LAST_BACKUP_METADATA
    echo "===================="
    return 1
  fi
}

function reset_backup() {
  utils/btrfs/clear-snapshots.sh
  utils/metadata/clear-metadata.sh
}

function encrypt() {
  ./utils/encryption/${ENCRYPTION_METHOD}/encrypt.sh
}

function decrypt() {
  ./utils/encryption/${ENCRYPTION_METHOD}/decrypt.sh
}


function load_encryption_key() {
  echo "Doing nothing for now"
}

if [ "$1" == 'backup' ]; then
  echo "doing backup"
  do_backup
elif [ "$1" == 'restore' ]; then
  echo "doing restore"
  do_restore
else
  echo "use 'escape.sh backup' or 'escape.sh restore'"
fi

cd ${OLD_DIR}
