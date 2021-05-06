#!/usr/bin/with-contenv bash
source ./common.sh

## Check if default user exists
if ! $(id husky &> /dev/null); then
    err "Default user doesn't exist"
    exit 1
fi

## If we run this script as a root, then we need to set proper permissions and ids
if [[ $(id -u) == 0 ]]; then

    ## Change user id if specified and is different from current
    if [[ ! -z "$CUSTOM_UID" && "$(id -u husky)" != "$CUSTOM_UID" ]]; then
        usermod -o -u $CUSTOM_UID husky
        msg "Set UID value: $(id -u husky)"
    fi

    # Change group id if specified and is different from current
    if [[ ! -z "$CUSTOM_GID" && "$(id -g husky)" != "$CUSTOM_GID" ]]; then
        groupmod -o -g $CUSTOM_GID husky
        msg "Set GID value: $(id -g husky)"
    fi

## In other case we check if we are running the script as a right user and exec it
elif [[ "$(whoami)" != "huksy" ]]; then
    err "Container is run with invalid user"
    exit 1
fi
