#!/usr/bin/with-contenv bash
source ./common.sh

## If we run this script as a root, then we need to set proper permissions and ids
if [[ $(id -u) == 0 ]]; then

    ## Change user id if specified and is different from current
    if [[ ! -z "$PUID" && "$(id -u husky)" != "$PUID" ]]; then
        usermod -o -u $PUID husky
        msg "Set UID value: $(id -u husky)"
    fi

    # Change group id if specified and is different from current
    if [[ ! -z "$PGID" && "$(id -g husky)" != "$PGID" ]]; then
        groupmod -o -g $PGID husky
        msg "Set GID value: $(id -g husky)"
    fi

## In other case we check if we are running the script as a right user and exec it
elif [[ "$(whoami)" != "huksy" ]]; then
    err "Container is run with invalid user"
    exit 1
fi
