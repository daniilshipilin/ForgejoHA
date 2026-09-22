FROM alpine:3.20

# Install dependencies via apk (Git 2.45+, OpenSSH, Bash, Curl, JQ)
RUN apk add --no-cache \
    bash \
    curl \
    git \
    jq \
    openssh-server \
    tzdata \
    ca-certificates \
    su-exec

# Download Forgejo binary for the correct architecture
ARG BUILD_ARCH
RUN case "${BUILD_ARCH}" in \
        amd64)   FORGEJO_ARCH="amd64"  ;; \
        aarch64) FORGEJO_ARCH="arm64"  ;; \
        *) echo "Unsupported arch: ${BUILD_ARCH}" && exit 1 ;; \
    esac && \
    curl -sSLf -o /usr/local/bin/forgejo \
        "https://codeberg.org/forgejo/forgejo/releases/download/v16.0.5/forgejo-16.0.5-linux-${FORGEJO_ARCH}" && \
    chmod +x /usr/local/bin/forgejo

# Create git user for Forgejo (UID/GID 1000)
RUN addgroup -g 1000 git && \
    adduser -D -u 1000 -G git -s /bin/bash git && \
    mkdir -p /home/git/.ssh && \
    chmod 700 /home/git/.ssh && \
    chown -R git:git /home/git

# Copy data for the add-on
COPY run.sh /
RUN chmod a+x /run.sh

# Build arguments
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

# Expose ports
EXPOSE 3000 22

# Define the command to run when the container starts
CMD [ "/run.sh" ]
