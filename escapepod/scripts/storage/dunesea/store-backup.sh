#!/bin/sh
source $(dirname "$0")/variables.sh
base64 | curl -d @- -X POST ${DUNESEA_URL}/api/v1/blob/${BACKUP_DOMAIN}/$1
