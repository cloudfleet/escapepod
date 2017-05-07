#!/bin/sh
set -e
function decrypt() {
  ./utils/encryption/${ENCRYPTION_METHOD}/decrypt.sh
}

BACKUP_METADATA=$(./storage/${STORAGE_DRIVER}/get-backup-metadata.sh $1 \
  | ./utils/encryption/${ENCRYPTION_METHOD}/decrypt.sh)
echo "Got metadata for $(echo ${BACKUP_METADATA} | jq -r .uuid)"
BLOB_HASH=$(echo ${BACKUP_METADATA} | jq -r .hash)
PREV_UUID=$(echo ${BACKUP_METADATA} | jq -r .prev)

if [ "${PREV_UUID}" ]; then
  echo "Parent is ${PREV_UUID}"
  $(dirname "$0")/recursive-restore.sh ${PREV_UUID}
fi

echo "Retrieving with hash ${BLOB_HASH}"
./storage/${STORAGE_DRIVER}/get-backup.sh ${BLOB_HASH} | decrypt | ./utils/btrfs/push-backup.sh
