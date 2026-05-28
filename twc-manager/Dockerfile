ARG BUILD_ARCH
FROM ghcr.io/home-assistant/base-debian:latest

# From: https://github.com/ngardiner/TWCManager/blob/main/contrib/docker/Dockerfile
# Changed base image to match Home Assistant's base image
# also replaced libatlas-base-dev with libopenblas-dev 

# Prevents Python from writing .pyc files and forces unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Allows installing pip packages at the system level in Python 3.11+
ENV PIP_BREAK_SYSTEM_PACKAGES=1

RUN apt-get -y update && apt-get -y install build-essential ca-certificates gfortran git libopenblas-dev libcap2-bin lsb-release make python3 python3-pip util-linux wget
RUN cd /usr/src && git clone https://github.com/ngardiner/TWCManager

# Install TWCManager
RUN cd /usr/src/TWCManager && make docker SUDO=""

VOLUME /etc/twcmanager
WORKDIR /usr/src/TWCManager

ENTRYPOINT ["./contrib/docker/entrypoint.sh"]
CMD ["/usr/bin/python3","-m","TWCManager"]
