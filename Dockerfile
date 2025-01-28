FROM ubuntu:24.04

RUN apt-get update && apt-get install --no-install-recommends -y curl=8.5.0-2ubuntu10.6 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/bin && touch /usr/bin/bazel  # allows the following `curl` to write, unsure why


RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    curl -Lo /usr/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.8.1/bazelisk-linux-amd64; \
  elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    curl -Lo /usr/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.8.1/bazelisk-linux-arm64; \
  else \
    echo "unknown $TARGETPLATFORM"; \
  fi && chmod +x /usr/bin/bazel

ENTRYPOINT [ "/usr/bin/bazel" ]
