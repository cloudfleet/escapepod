#!/bin/sh
source $(dirname "$0")/variables.sh
if [ $METADATA_DIR ]; then
  rm -rf ${METADATA_DIR}/*
fi
