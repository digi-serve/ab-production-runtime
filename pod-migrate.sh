#!/usr/bin/bash

# Uses the AB Migration Manager to update every tenant DB to the latest
# schema.


# Import ENV variables
set -o allexport
source .env
set +o allexport

podman pull docker.io/digiserve/ab-migration-manager:master

SCRIPT_DIR=`dirname -- $0`
ID=`podman container ls -f name=${STACKNAME}_api_sails`
if [ "$ID" == "" ]
then
    echo "${STACKNAME} is not running"
else
    podman run \
        -v ${SCRIPT_DIR}/config/local.js:/app/config/local.js \
        --network=${STACKNAME}_default \
        -e MYSQL_PASSWORD \
        digiserve/ab-migration-manager:master node app.js
fi
