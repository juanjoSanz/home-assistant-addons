ARG BUILD_ARCH
FROM ghcr.io/home-assistant/base-debian-python:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends git build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/ngardiner/TWCManager \
    && cd TWCManager \
    && git checkout main \
    && make install

COPY config.json /etc/twcmanager/config.json

ENTRYPOINT ["python3", "-m", "TWCManager"]