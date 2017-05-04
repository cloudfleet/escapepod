#!/bin/sh
source $(dirname "$0")/variables.sh
cat $METADATA_PATH/$(ls -lrc --color=never $METADATA_PATH/*.metadata | tail -n1 | awk '{print $(NF)}')
