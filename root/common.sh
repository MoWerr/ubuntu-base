#!/bin/bash

## Prints simple message
function msg {
    echo " --->" $*
}

## Prints error message
function err {
    >&2 echo " --->" $*
}

## Checks if given directory exists.
## If not, it will create one.
function check_dir {
    if [[ ! -d "$1" ]]; then
        mkdir -p "$1"
        msg "Directory created: $1"
    fi
}