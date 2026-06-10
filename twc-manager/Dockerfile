ARG BUILD_ARCH
FROM ghcr.io/home-assistant/base-debian:bullseye

# From: https://github.com/ngardiner/TWCManager/blob/main/contrib/docker/Dockerfile
# Changed base image to match Home Assistant's base image
# also replaced libatlas-base-dev with libopenblas-dev 

RUN apt-get -y update && apt-get -y install build-essential ca-certificates gfortran git libatlas-base-dev libcap2-bin lsb-release make python3 python3-pip util-linux wget
RUN cd /usr/src && git clone https://github.com/ngardiner/TWCManager

# Install TWCManager
RUN cd /usr/src/TWCManager && make docker SUDO=""

# Cleanup
RUN apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

VOLUME /etc/twcmanager
WORKDIR /usr/src/TWCManager

ENTRYPOINT ["./contrib/docker/entrypoint.sh"]
CMD ["/usr/bin/python3","-m","TWCManager"]
