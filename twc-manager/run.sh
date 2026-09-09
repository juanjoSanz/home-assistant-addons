#!/usr/bin/with-contenv bashio

bashio::log.info $(cat /etc/os-release)
bashio::log.info "Preparing to start..."

# Entrypoint script for Docker image of TWCManager.
# We use this to prepare the configuration for the first time
if [ ! -e "/etc/twcmanager/config.json" ]; then
    cp /usr/src/TWCManager/etc/twcmanager/config.json /etc/twcmanager/config.json
    chown twcmanager:twcmanager /etc/twcmanager /etc/twcmanager/config.json
fi

# Serial enabled - set port
if bashio::config.true 'serial.enabled'; then
    bashio::log.info "Serial enabled"
    ## Get variables from the user config options.
    serial_dev=$(bashio::config 'serial.device')
    serial_baud=$(bashio::config 'serial.baud')

    ## Change config file to use $serial_dev $serial_baud
    bashio::log.info "Setting $serial_dev Serial interface..."
    sed -id "s|/dev/ttyUSB0|$serial_dev|" /etc/twcmanager/config.json
    sed -id "s|\"baud\": 9600,|\"baud\": $serial_baud,|" /etc/twcmanager/config.json
fi

/usr/bin/python3 -m TWCManager 