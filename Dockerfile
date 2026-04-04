# Build stage
FROM cgr.dev/chainguard/rust:latest-dev AS builder

ARG USE_GH_RELEASE=true
ARG ZOLA_RELEASE_VERSION=latest
USER root
RUN apk add --no-cache pkgconf make gcc openssl-dev curl jq gzip
USER nonroot

WORKDIR /app
COPY . .

RUN if [ "${USE_GH_RELEASE}" = "true" ]; then \
    if [ "${ZOLA_RELEASE_VERSION}" = "latest" ]; then \
      export ZOLA_VERSION=$(curl -sL https://api.github.com/repos/getzola/zola/releases/latest | jq -r .name); \
    else \
      export ZOLA_VERSION="${ZOLA_RELEASE_VERSION}"; \
    fi && \
    curl -sL --fail --output zola.tar.gz https://github.com/getzola/zola/releases/download/${ZOLA_VERSION}/zola-${ZOLA_VERSION}-$(uname -m)-unknown-linux-gnu.tar.gz && \
    tar -xzvf zola.tar.gz zola; \
  else \
    cargo build --release && \
    cp target/$(uname -m)-unknown-linux-gnu/release/zola zola; \
  fi && ./zola --version


# Run stage
FROM cgr.dev/chainguard/glibc-dynamic:latest

LABEL org.opencontainers.image.source="https://github.com/some-natalie/zola-in-a-can"
LABEL org.opencontainers.image.path="Dockerfile"
LABEL org.opencontainers.image.title="Zola in a Can"
LABEL org.opencontainers.image.description="Zola in a container for local static site development"
LABEL org.opencontainers.image.authors="Natalie Somersall (@some-natalie)"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.documentation="https://github.com/some-natalie/zola-in-a-can/README.md"

COPY --from=builder --chown=65532:65532 /app/zola /usr/bin/zola

ENTRYPOINT [ "/usr/bin/zola" ]
