# Defines what ubuntu version will be used as a base for this image.
ARG UBUNTU_TAG="latest"

# We always base on ubuntu image.
FROM ubuntu:${UBUNTU_TAG}

# Read data from buildx
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-linux/amd64}

# The umask will be updated during runtime.
# Unspecified value will leave umask value as is.
ENV UMASK="" \
    # If the docker will be run as a root (inside container),
    # then it is possible to adapt UID and GID during startup with those envs.
    CUSTOM_UID="" \
    CUSTOM_GID="" \
    TERM="xterm"

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

# s6 overlay configuration
# s6 architecture will be determined from $TARGETARCH variable
ARG S6_VER="v2.2.0.3"

# Load script that allows to determine the s6 architecture
COPY root/etc/s6-arch-picker.sh /etc/s6-arch-picker.sh

# Add s6 overlay
RUN set -x && \
    curl -sL https://github.com/just-containers/s6-overlay/releases/download/${S6_VER}/s6-overlay-$(/etc/s6-arch-picker.sh)-installer -o /tmp/s6-overlay-installer && \
    chmod +x /tmp/s6-overlay-installer && \
    /tmp/s6-overlay-installer / && \
    rm /tmp/s6-overlay-installer

# Tell s6 overlay to exit whenever the initialization stage fails
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Arguments that allows to override the default uid/gid values
ONBUILD ARG UID=1000
ONBUILD ARG GID=1000

# Create default user and usergroup
ONBUILD RUN set -x && \
    groupadd -o -g $GID husky && \
    useradd -md /data -g husky -u $UID husky

# Sets environment to be user-like for s6-setuidgid purposes
ENV HOME=/data \
    USER=husky

COPY root/ /

ENTRYPOINT [ "./init" ]