#!/bin/sh
source $(dirname "$0")/variables.sh
mkdir -p ${METADATA_PATH}
cat > ${METADATA_PATH}/$1.metadata
