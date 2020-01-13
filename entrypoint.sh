#!/usr/bin/env sh

# Using socat to forward all traffic directed to the wrapper container on to the actual application.
# https://stackoverflow.com/questions/46099874/how-can-i-forward-a-port-from-one-docker-container-to-another
socat TCP-LISTEN:${SERVICE_PORT},fork TCP:${STACK_NAME}_${SERVICE_NAME}_app:${SERVICE_PORT} &

env_vars=""
IFS_BACK=$IFS
IFS="
"
for env_var in $( env ); do
    # TODO: These don't seem to work?
    if [ "$(echo "$env_var" | cut -d "=" -f1 | xargs)" = "" ]; then continue; fi
    if [ "$(echo "$env_var" | cut -d "=" -f1 )" = "PATH" ]; then continue; fi
    if [ "$(echo "$env_var" | cut -d "=" -f1 )" = "PWD" ]; then continue; fi
    if [ "$(echo "$env_var" | cut -d "=" -f1 )" = "HOME" ]; then continue; fi
    if [ "$(echo "$env_var" | cut -d "=" -f1 )" = "HOSTNAME" ]; then continue; fi
    if [ "$(echo "$env_var" | cut -d "=" -f1 )" = "SHLVL" ]; then continue; fi
    if [ "$(echo "$env_var" | cut -d "=" -f1 )" = "STACK_NAME" ]; then continue; fi
    if [ "$(echo "$env_var" | cut -d "=" -f1 )" = "SERVICE_NAME" ]; then continue; fi
    if [ "$(echo "$env_var" | cut -d "=" -f1 )" = "VOLUMES_TO_MOUNT" ]; then continue; fi
    if [ "$(echo "$env_var" | cut -d "=" -f1 )" = "CAP_PRIVS" ]; then continue; fi
    if [ "$(echo "$env_var" | cut -d "=" -f1 )" = "IMAGE_TO_RUN" ]; then continue; fi

    env_vars=" $env_vars -e $env_var "
done
IFS=$IFS_BACK

docker run --rm \
    --name ${STACK_NAME}_${SERVICE_NAME}_app \
    -t \
    $NETWORKS \
    $env_vars \
    $PORTS  \
    $VOLUMES_TO_MOUNT \
    $CAP_PRIVS \
    $IMAGE_TO_RUN \
    $COMMAND

