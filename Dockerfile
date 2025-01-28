FROM ubuntu:24.04
ARG TARGETPLATFORM

RUN apt-get update && apt-get install --no-install-recommends -y curl=8.5.0-2ubuntu10.6 ca-certificates=20240203 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/bin && touch /usr/bin/bazel  # allows the following `curl` to write, unsure why

RUN case "$TARGETPLATFORM" in \
  "linux/amd64") curl -Lo /usr/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.8.1/bazelisk-linux-amd64 || exit 1;; \
  "linux/arm64") curl -Lo /usr/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.8.1/bazelisk-linux-arm64 || exit 1;; \
  *) echo "unknown platform: [$TARGETPLATFORM]"; exit 1;; \
  esac && chmod +x /usr/bin/bazel

ENTRYPOINT [ "/usr/bin/bazel" ]
