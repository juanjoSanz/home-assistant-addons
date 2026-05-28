ARG BUILD_ARCH
FROM ghcr.io/hassio-addons/base-python:latest

RUN git clone https://github.com/ngardiner/TWCManager \
    && cd TWCManager \
    && git checkout main \
    && make install

COPY config.json /etc/twcmanager/config.json

ENTRYPOINT ["python3", "-m", "TWCManager"]