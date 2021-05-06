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

# s6 overlay configuration
ARG S6_VER="v2.2.0.3"
ARG S6_ARCH="amd64"

# Install common dependencies
RUN set -x && \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        locales \
        wget \
        curl \
        ca-certificates \
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

# Add s6 overlay
RUN set -x && \
    curl -sL https://github.com/just-containers/s6-overlay/releases/download/${S6_VER}/s6-overlay-${S6_ARCH}-installer -o /tmp/s6-overlay-installer && \
    chmod +x /tmp/s6-overlay-installer && \
    /tmp/s6-overlay-installer / && \
    rm /tmp/s6-overlay-installer

# Tell s6 overlay to exit whenever the initialization stage fails
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Create default user and usergroup
RUN set -x && \
    groupadd husky && \
    useradd -md /data -g husky husky

# Sets environment to be user-like for s6-setuidgid purposes
ENV HOME=/data \
    USER=husky

COPY root/ /

ENTRYPOINT [ "./init" ]