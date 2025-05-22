FROM ubuntu:24.04

ARG TARGETPLATFORM
ARG VER_BAZELISK

RUN apt-get update && apt-get install --no-install-recommends -y curl=8.5.0-2ubuntu10.6 ca-certificates=20240203 gcc g++ jq && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/bin && touch /usr/bin/bazel  # allows the following `curl` to write, unsure why

RUN case "$TARGETPLATFORM" in \
  "linux/amd64") curl -Lo /usr/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v$VER_BAZELISK/bazelisk-linux-amd64 || exit 1;; \
  "linux/arm64") curl -Lo /usr/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v$VER_BAZELISK/bazelisk-linux-arm64 || exit 1;; \
  *) echo "unknown platform: [$TARGETPLATFORM]"; exit 1;; \
  esac && chmod +x /usr/bin/bazel

RUN useradd -ms /bin/bash builder
USER builder
WORKDIR /home/builder

ENTRYPOINT [ "/usr/bin/bazel" ]
