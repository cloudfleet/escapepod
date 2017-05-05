#!/bin/sh
set -e
source $(dirname "$0")/variables.sh
clear_snapshot ${ROOT_SNAPSHOT}
clear_snapshot ${LAST_PARENT}
clear_snapshot ${CURRENT_PARENT}
clear_snapshot ${CURRENT_STATE}
