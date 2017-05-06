#!/bin/sh
source $(dirname "$0")/variables.sh
if [ -f ${BLOB_PATH}/$1 ]; then
  cat ${BLOB_PATH}/$1
else
  echo "Did not find backup at ${BLOB_PATH}/$1" 1>&2
  echo "no-remote-backup"
fi
