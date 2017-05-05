#!/bin/sh
set -e
source $(dirname "$0")/variables.sh
if snapshot_exists ${CURRENT_STATE} ; then
  echo "incremental"
else
  echo "full"
fi
