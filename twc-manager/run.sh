#!/usr/bin/with-contenv bashio

bashio::log.info $(cat /etc/os-release)
bashio::log.info "Preparing to start..."


# Entrypoint script for Docker image of TWCManager.
# Prepare the configuration for the first time

#cp /usr/src/TWCManager/etc/twcmanager/config.json /etc/twcmanager/config.json
#chown twcmanager:twcmanager /etc/twcmanager /etc/twcmanager/config.json
cp /config.json /etc/twcmanager/config.json

# Serial enabled - set port
if bashio::config.true 'serial.enabled'; then

    ## Get variables from the user config options.
    serial_dev=$(bashio::config 'serial.device')
    serial_baud=$(bashio::config 'serial.baud')
    fuse_amps=$(bashio::config 'config.fuseAmps')
    phases=$(bashio::config 'config.phases')
    twc_address=$(bashio::config 'config.twc_ip')

    ## Change config file
    bashio::log.info "Setting USB SERIAL with $serial_dev and $serial_baud..."
    sed -id "s|###USBPORT_GEN3###|$serial_dev|" /etc/twcmanager/config.json
    sed -id "s|###USBPORT_BAUDRATE###|$serial_baud|" /etc/twcmanager/config.json
    bashio::log.info "Setting ###FUSEAMPS### with $fuse_amps..."
    sed -id "s|###FUSEAMPS###|$fuse_amps|" /etc/twcmanager/config.json
    sed -id "s|###PHASES###|$phases|" /etc/twcmanager/config.json
    bashio::log.info "Setting ###IP_GEN3### with $twc_address..."
    sed -id "s|###IP_GEN3###|$twc_address|" /etc/twcmanager/config.json

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


/usr/bin/python3 -m TWCManager 