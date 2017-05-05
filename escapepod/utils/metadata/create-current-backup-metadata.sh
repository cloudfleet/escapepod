#!/bin/sh
source $(dirname "$0")/variables.sh
export STORAGE_DRIVER
BACKUP_UUID=$(uuidgen -t)
BACKUP_DATE=$(date -u +"%Y-%m-%dT%H%M%SZ")
BACKUP_SIZE=$(utils/btrfs/get-current-backup.sh | wc -c)
BACKUP_HASH=$(utils/btrfs/get-current-backup.sh | sha512sum)
BACKUP_TYPE=$(utils/btrfs/get-current-backup-type.sh)
METADATA_FILE=${METADATA_PATH}/$BACKUP_UUID.metadata
cat > ${METADATA_FILE} <<JSON
{
  "uuid": "$BACKUP_UUID",
  "date": "$BACKUP_DATE",
  "size": $BACKUP_SIZE,
  "hash": "$BACKUP_HASH",
  "type": "$BACKUP_TYPE"
}
JSON
echo METADATA_FILE
