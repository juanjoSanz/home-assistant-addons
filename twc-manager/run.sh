#!/usr/bin/with-contenv bashio

bashio::log.info $(cat /etc/os-release)
bashio::log.info "Preparing to start..."

# Entrypoint script for Docker image of TWCManager.
# We use this to prepare the configuration for the first time
if [ ! -e "/etc/twcmanager/config.json" ]; then
    #cp /usr/src/TWCManager/etc/twcmanager/config.json /etc/twcmanager/config.json
    #chown twcmanager:twcmanager /etc/twcmanager /etc/twcmanager/config.json
    cp /config.json /etc/twcmanager/config.json


    # Serial enabled - set port
    if bashio::config.true 'serial.enabled'; then

        ## Get variables from the user config options.
        serial_dev=$(bashio::config 'serial.device')
        serial_baud=$(bashio::config 'serial.baud')
        twc_address=$(bashio::config 'config.twc_ip')
        fuse_amps=$(bashio::config 'config.fuseAmps')
        phases=$(bashio::config 'config.phases')

        ## Change config file to use $serial_dev $serial_baud
        bashio::log.info "Setting $serial_dev Serial interface with $serial_baud..."
        #sed -id "s|/dev/ttyUSB0|$serial_dev|" /etc/twcmanager/config.json
        #sed -id "s|\"baud\": 9600,|\"baud\": $serial_baud,|" /etc/twcmanager/config.json
        sed -id "s|###USBPORT_GEN3###|$serial_dev|" /etc/twcmanager/config.json
        sed -id "s|###USBPORT_GEN2###|$twc_address|" /etc/twcmanager/config.json
        sed -id "s|###FUSEAMPS###|$fuse_amps|" /etc/twcmanager/config.json
        sed -id "s|###PHASES###|$phases|" /etc/twcmanager/config.json

    fi


    if bashio::config.true 'mqtt.enabled'; then

        ## Get variables from the user config options.
        mqtt_broker=$(bashio::config 'mqtt.mqttBroker')
        mqtt_port=$(bashio::config 'mqtt.mqttPort')
        mqtt_user=$(bashio::config 'mqtt.mqttUser')
        mqtt_pass=$(bashio::config 'mqtt.mqttPass')
        mqtt_consumption_topic=$(bashio::config 'mqtt.mqttConsumptionTopic')
        mqtt_generation_topic=$(bashio::config 'mqtt.mqttGenerationTopic')

        ## Change config file to use MQTT variables
        bashio::log.info "Setting MQTT broker ..."
        sed -id "s|###MQTTENABLE###|true|" /etc/twcmanager/config.json
        sed -id "s|###MQTTBROKER###|$mqtt_broker|" /etc/twcmanager/config.json
        sed -id "s|###MQTTPORT###|$mqtt_port|" /etc/twcmanager/config.json
        sed -id "s|###MQTTUSER###|$mqtt_user|" /etc/twcmanager/config.json
        sed -id "s|###MQTTPASS###|$mqtt_pass|" /etc/twcmanager/config.json
        sed -id "s|###MQTT_CONSUMPTION_TOPIC###|$mqtt_consumption_topic|" /etc/twcmanager/config.json
        sed -id "s|###MQTT_GENERATION_TOPIC###|$mqtt_generation_topic|" /etc/twcmanager/config.json
    else
        bashio::log.info "MQTT disabled"
        sed -id "s|###MQTTENABLE###|false|" /etc/twcmanager/config.json
    fi

fi

/usr/bin/python3 -m TWCManager 