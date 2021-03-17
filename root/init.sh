#!/bin/bash
source ./common.sh

## Check if default user exists
if ! $(id husky &> /dev/null); then
    err "Default user doesn't exist"
    exit 1
fi

## Set umask value if necessary
if [[ ! -z "$UMASK" ]]; then
    umask $UMASK
    msg "Set UMASK value: $(umask)"
else
    msg "UMASK variable is not provided. UMASK won't be changed."
fi

## Run hook script if it exists
if [[ -f "/hooks/init.sh" ]]; then
    /hooks/init.sh
fi

## If we run this script as a root, then we need to set proper permissions
## and downgrade to a lower privileged user.
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

    msg "Running ./entrypoint.sh $* command as a default user"
    exec gosu husky ./entrypoint.sh "$@"
fi

## In other case we check if we are running the script as a right user and exec it
if [[ "$(whoami)" != "huksy" ]]; then
    err "Container is run with invalid user"
    exit 1
fi

msg "Running ./entrypoint.sh $* command as a default user (set from docker run command)"
exec ./entrypoint.sh "$@"
