#!/usr/bin/with-contenv bash
source ./common.sh

## Check if default user exists
if ! $(id husky &> /dev/null); then
    err "Default user doesn't exist"
    exit 1
fi