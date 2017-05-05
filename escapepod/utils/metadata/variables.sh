#!/bin/sh
if [ $1 ]; then
  STORAGE_DRIVER=$1
fi
METADATA_DIR=${DATA_VOLUME}/.snapshots/${STORAGE_DRIVER}/metadata
