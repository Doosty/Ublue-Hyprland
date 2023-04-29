ARG FEDORA_MAJOR_VERSION=37
ARG BASE_CONTAINER_URL=ghcr.io/ublue-os/silverblue-main

FROM ${BASE_CONTAINER_URL}:${FEDORA_MAJOR_VERSION}
ARG RECIPE

# copy over configuration files
COPY etc /etc
COPY usr /usr

COPY ${RECIPE} /tmp/ublue-recipe.yml

# yq used in build.sh and the setup-flatpaks recipe to read the recipe.yml
# copied from the official container image as it's not avaible as an rpm
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

# copy and run the build script
COPY build.sh /tmp/build.sh
RUN chmod +x /tmp/build.sh && /tmp/build.sh

# copy and setup binaries
COPY apps /tmp/apps
RUN chmod +x /tmp/apps/setup-apps.sh && /tmp/apps/setup-apps.sh

# clean up and finalize container build
RUN rm -rf \
        /tmp/* \
        /var/* && \
    ostree container commit

# fix for ublue base-main booting into a black screen
RUN systemctl enable getty@tty1
