#!/bin/sh
set -e
source $(dirname "$0")/variables.sh
snapshot_exists ${DATA_VOLUME}
