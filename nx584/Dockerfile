ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add python3 py3-pip git
RUN pip3 install --upgrade pip

RUN git clone https://github.com/kk7ds/pynx584
RUN pip3 install pynx584/

## Possible feature: mqtt
## https://github.com/rocket4321/nx584mqtt/tree/main/nx584mqtt
## pip install nx584mqtt

# Verify python installation
RUN which python3

# Verify package installation location
RUN /usr/bin/nx584_server --help

WORKDIR /usr/app/src
# config.ini to be created in run.sh
# COPY config.ini .
COPY config.ini_template config.ini_template

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
