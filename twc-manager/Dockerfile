ARG BUILD_FROM
FROM $BUILD_FROM

RUN git clone https://github.com/ngardiner/TWCManager \
    && cd TWCManager \
    && git checkout main \
    && make install

COPY config.json /etc/twcmanager/config.json

ENTRYPOINT ["python3 -m TWCManager]