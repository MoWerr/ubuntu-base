# Defines what ubuntu version will be used as a base for this image.
ARG UBUNTU_TAG="latest"

# We always base on ubuntu image.
FROM ubuntu:${UBUNTU_TAG}

# The umask will be updated during runtime.
# Unspecified value will leave umask value as is.
ENV UMASK="" \
    # If the docker will be run as a root (inside container),
    # then it is possible to adapt UID and GID during startup with those envs.
    PUID="" \
    PGID="" \
    TERM="xterm"

# Update the packages and install common dependencies
RUN set -x && \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        locales \
        wget \
        curl \
        ca-certificates \
        gosu \
    && \
    # Cleanup
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    # Generate locale files for en_US
    locale-gen en_US.UTF-8

# Set locale envs
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US \
    LC_ALL=en_US.UTF-8

# Create default user and usergroup
RUN set -x && \
    groupadd -o -g ${GID} husky && \
    useradd -md /data -o -u ${UID} -g husky husky

COPY root/ /

ENTRYPOINT [ "./init.sh" ]