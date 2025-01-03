# Base image setup
FROM debian:bullseye-slim

# Set the Wyoming Whisper version
ARG WYOMING_WHISPER_VERSION=2.4.0

# Environment setup
WORKDIR /usr/src

# Install dependencies and Wyoming Faster Whisper
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        python3 \
        python3-dev \
        python3-pip \
    && pip3 install --no-cache-dir -U \
        setuptools \
        wheel \
    && pip3 install --no-cache-dir \
        --extra-index-url https://www.piwheels.org/simple \
        "wyoming-faster-whisper @ https://github.com/rhasspy/wyoming-faster-whisper/archive/refs/tags/v${WYOMING_WHISPER_VERSION}.tar.gz" \
    && apt-get purge -y --auto-remove \
        build-essential \
        python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /

# Copy the runtime script
COPY run.sh ./

# Expose relevant ports
EXPOSE 10300/tcp

# Entry point for the container
ENTRYPOINT ["/run.sh"]
