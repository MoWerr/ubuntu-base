# ubuntu-base

## Table of contents
* [Overview](#overview)
* [Releases](#releases)
* [`OBUILD` arguments](#onbuild-arguments)
* [Environment variables](#env-variables)
* [Build `ARG`s](#build-args)
* [Default user](#default-user)
* [Working directory](#working-directory)
* [Initialization](#initialization)

## Overview
This is a base image for my other docker images. Its main purposes are:
* Downloading and installing [s6-overlay](https://github.com/just-containers/s6-overlay)
* Downloading and installing common dependencies (e.g. curl)
* Providing common configuration (e.g. properly configured locales)
* Creating default user (`husky`) and handling its UID/GID
* Handling UMASK value

## Releases
Currently there are ready-to-use images available on [Docker Hub](https://hub.docker.com/repository/docker/mowerr/ubuntu-base). All of them ale multi-architectural and supports linux/amd64, linux/arm/v7 and linux/arm64.

| Docker tag      | Description
| ---             | ---
| `latest`        | Uses `ubuntu:latest` as a base image.
| `20.04`         | Uses `ubuntu:20.04` as a base image.
| `18.04`         | Uses `ubuntu:18.04` as a base image.

## `OBUILD` arguments
As this image is designed to be a base for others it includes some useful `ONBUILD` arguments. All of them have default values, so specifying them during child image build is fully optional.

| Argument    | Default value     | Description
| ---         | ---               | ---
| `UID`       | 1000              | Default user will be created with given uid.
| `GID`       | 1000              | Default usergroup will be created with given gid.

## Environment variables
This image exposes also some configuration environment variables. All images based on this one will inherit possibility of using those. All of them are fully optional.

| Variable      | Description
| ---           | ---
| `CUSTOM_UID`  | Allows to override the uid of the default user. It will be done at the container startup (requires root privileges).
| `CUSTOM_GID`  | Allows to override the gid of the default usergroup. It will be done at the container startup (requires root privileges).
| `UMASK`       | Allows to set umask to given value. It will be done at the container startup.

## Build `ARG`s
This dockerfile accepts also some `ARG`s, so it is possible to build this base-image targeting different `ubuntu` and `s6-overlay` versions.

| Argument    | Default value     | Description
| ---         | ---               | ---
| `UBUNTU_TAG`| latest            | Defines tag of the `ubuntu` image that will be used as a base for this image.
| `S6_VER`    | v2.2.0.3          | Defines which version of the `s6-overlay` will be used.

## Default user
This image will take care of creating default user that will be named `husky`. Why `husky` you ask? Well... huskies are great! That's it! This user will be added to a usergroup that will also be named `husky`.

As there will be `s6-overlay` installed I expect users (and myself) to run programs and scripts using `s6-setuidgid`. There is caveat here. This tool sets only uid and gid for the execution (it's not the full login flow), so other things (like `$HOME` variable) are not set properly. This image takes care of those things and creates user-like environment for running your programs.

## Working directory
The `$HOME` variable and home directory for `husky` are set to `/data`. It is good practice to use this directory for all the data that needs some kind of persistance or mapping to the host filesystem.

## Initialization
This image takes advantage of the `s6-overlay` initialization flow and performs some operations through scripts located inside the `/etc/cont-init.d` directory. Scripts in this location are executed in the alphabetical order, so some assumptions has been made:
* All init scripts should start with a two digit number that defines execution order (e.g. `00-welcome.sh`).
* Numbers 00-09 are reserved for this image (so the children can use numbers in range 10-99).