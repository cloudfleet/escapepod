#!/bin/sh
source $(dirname "$0")/variables.sh
mkdir -p ${METADATA_PATH}
if [ -z "$1" ]; then
  BACKUP_ID=$(ls -lrc --color=never $METADATA_PATH | awk '{print $(NF)}' | grep "metadata$" | tail -n1)
else
  BACKUP_ID=$1.metadata
fi
if [ -f ${METADATA_PATH}/${BACKUP_ID} ]; then
  cat ${METADATA_PATH}/${BACKUP_ID}
else
  echo "no-local-metadata - tried to read ${METADATA_PATH}/${BACKUP_ID}"
fi
