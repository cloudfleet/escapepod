#!/bin/sh
source $(dirname "$0")/variables.sh
if [ $METADATA_PATH ]; then
  rm -rf ${METADATA_PATH}/*
fi
