#!/bin/sh
source $(dirname "$0")/variables.sh
if [ -z "$1" ]; then
  BACKUP_ID=$(ls -lrc --color=never $METADATA_PATH/*.metadata | tail -n1 | awk '{print $(NF)}')
else
  BACKUP_ID=$1.metadata
fi

cat ${METADATA_PATH}/${BACKUP_ID}
