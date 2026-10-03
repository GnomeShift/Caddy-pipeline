# Version that xcaddy compiles, may be newer than the published images
ARG CADDY_TARGET_VERSION=2.11.7

# Version of the builder-alpine and alpine images that exist in Docker Hub
ARG CADDY_BASE_VERSION=2.11.4

# Stage 1: Build
FROM caddy:${CADDY_BASE_VERSION}-builder-alpine AS builder

ARG CADDY_TARGET_VERSION
ARG CADDY_MODULES="github.com/caddy-dns/cloudflare github.com/greenpau/caddy-security github.com/mholt/caddy-l4"

ENV CADDY_VERSION=v${CADDY_TARGET_VERSION}
WORKDIR /build

RUN set -eu; \
    set -f; \
    set --; \
    for mod in ${CADDY_MODULES}; do \
      set -- "$@" --with "$mod"; \
    done; \
    CGO_ENABLED=0 xcaddy build "${CADDY_VERSION}" \
      --output /build/caddy "$@" && /build/caddy version

# Stage 2: Alpine
FROM caddy:${CADDY_BASE_VERSION}-alpine

ARG CADDY_TARGET_VERSION
ENV CADDY_VERSION=v${CADDY_TARGET_VERSION}
COPY --from=builder /build/caddy /usr/bin/caddy
