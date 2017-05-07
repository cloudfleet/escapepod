#!/bin/sh
source $(dirname "$0")/variables.sh
echo ${DUNESEA_URL}/api/v1/metadata/${BACKUP_DOMAIN}/$1
curl -d @- -X POST ${DUNESEA_URL}/api/v1/metadata/${BACKUP_DOMAIN}/$1
