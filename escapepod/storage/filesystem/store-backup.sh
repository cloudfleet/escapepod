#!/bin/sh
source $(dirname "$0")/variables.sh
mkdir -p ${BLOB_PATH}
cat > ${BLOB_PATH}/$1
