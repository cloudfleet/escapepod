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
  echo "Taking snapshot..."
  utils/btrfs/take-snapshot.sh
  echo "Creating metadata"
  METADATA_FILE=$(utils/metadata/create-current-backup-metadata.sh)

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
    | ./utils/encryption/${ENCRYPTION_METHOD}/decrypt.sh)
  LOCAL_LAST_BACKUP_METADATA=$(./utils/metadata/get-backup-metadata.sh)

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
  echo "doing restore - NOT IMPLEMENTED YET"
else
  echo "use 'escape.sh backup' or 'escape.sh restore'"
fi

cd ${OLD_DIR}
