#!/bin/sh
source $(dirname "$0")/variables.sh
curl ${DUNESEA_URL}/api/v1/metadata/${BACKUP_DOMAIN}/$1
