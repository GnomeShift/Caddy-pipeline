# Version that xcaddy compiles, may be newer than the published images
ARG CADDY_TARGET_VERSION=2.11.7

# Version of the builder-alpine and alpine images that exist in Docker Hub
ARG CADDY_BASE_VERSION=2.11.4

# caddy:2.11-alpine uses pinned tag
ARG CADDY_ALPINE_VERSION=3.23

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
      --output /build/caddy "$@" && \
    BUILT="$(/build/caddy version | head -n1)"; \
    setcap cap_net_bind_service=+ep /build/caddy && \
    CAP="$(getcap /build/caddy)" && \
    [ -n "$CAP" ] || { echo "FATAL: setcap had no effect" >&2; exit 1; };

# Stage 2: Alpine
FROM alpine:${CADDY_ALPINE_VERSION}

RUN apk add --no-cache ca-certificates curl libcap mailcap

RUN set -eux; \
	mkdir -p /config/caddy /data/caddy /etc/caddy /usr/share/caddy ; \
	chmod 1777 /config/caddy /data/caddy

ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ARG CADDY_TARGET_VERSION
ENV CADDY_VERSION=v${CADDY_TARGET_VERSION}

LABEL org.opencontainers.image.version=v${CADDY_TARGET_VERSION} \
      org.opencontainers.image.title=Caddy \
      org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go" \
      org.opencontainers.image.url=https://caddyserver.com \
      org.opencontainers.image.documentation=https://caddyserver.com/docs \
      org.opencontainers.image.vendor="Light Code Labs" \
      org.opencontainers.image.licenses=Apache-2.0 \
      org.opencontainers.image.source="https://github.com/caddyserver/caddy-docker"

COPY --from=builder /build/caddy /usr/bin/caddy

RUN caddy version

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /srv

RUN wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/config/Caddyfile" \
    && wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/welcome/index.html"

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
