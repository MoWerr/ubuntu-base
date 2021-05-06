#!/usr/bin/with-contenv bash
source ./common.sh

## Set umask value if necessary
if [[ ! -z "$UMASK" ]]; then
    umask $UMASK
    msg "Set UMASK value: $(umask)"
else
    msg "UMASK variable is not provided. UMASK won't be changed."
fi