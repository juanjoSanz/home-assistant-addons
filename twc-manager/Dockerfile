ARG BUILD_ARCH
FROM ghcr.io/home-assistant/base-debian:latest

# bypass sudo
RUN echo '#!/bin/sh' > /usr/bin/sudo \
    && echo 'exec "$@"' >> /usr/bin/sudo \
    && chmod +x /usr/bin/sudo \
    && apt-get update \
    && apt-get install -y --no-install-recommends git build-essential python3 python3-pip \
    && git clone https://github.com/ngardiner/TWCManager \
    && cd TWCManager \
    && git checkout main \
    && make install \
    && apt-get purge -y --auto-remove git build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY config.json /etc/twcmanager/config.json

ENTRYPOINT ["python3", "-m", "TWCManager"]
