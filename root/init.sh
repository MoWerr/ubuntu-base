#!/bin/bash
source ./common.sh

## Check if all required arguments has been provided
if [[ $# < 2 ]]; then
    err "Init script requires at least two arguments: username command [arg]..."
    exit 1
fi

## Read name of the executing user
USERNAME=$1 && shift

## Check if provided user exists
if ! $(id "$USERNAME" &> /dev/null); then
    err "Provided user doesn't exist"
    exit 1
fi

## Set umask value if necessary
if [[ ! -z "$UMASK" ]]; then
    msg "Setting UMASK to provided value..."
    umask $UMASK && read_value=$(umask) && msg "Set UMASK to value: $read_value"
else
    msg "UMASK variable is not provided. UMASK won't be changed."
fi

## If we run this script as a root, then we need to set proper permissions
## and downgrade to the lower privileged user.
if [[ $(id -u) == 0 ]]; then

    ## Change user id if specified and is different from current
    if [[ ! -z "$PUID" && "$(id -u $USERNAME)" != "$PUID" ]]; then
        usermod -o -u $PUID $USERNAME
        msg "Set '$USERNAME' UID to value: $(id -u $USERNAME)"
    fi

    # Change group id if specified and is different from current
    # We assume that the group name matcher the name of the user
    if [[ ! -z "$PGID" && "$(id -g $USERNAME)" != "$PGID" ]]; then
        groupmod -o -g $PGID $USERNAME
        msg "Set '$USERNAME' GID to value: $(id -g $USERNAME)"
    fi

    msg "Running $* command as a '$USERNAME' user"
    exec gosu $USERNAME "$@"
fi

## In other case we check if we are running the script as a right user and exec it
if [[ "$(whoami)" != "$USERNAME" ]]; then
    err "Container is run with invalid user"
    exit 1
fi

msg "Running $* command as a '$USERNAME' user (set from docker run command)"
exec "$@"
