#!/usr/bin/with-contenv bashio

bashio::log.info $(cat /etc/os-release)
bashio::log.info "Preparing to start..."

debug_enabled=$(bashio::config 'debug_enabled')
if [ "$debug_enabled" = "true" ]; then
    bashio::log.info "Debug enabled, setting log level to DEBUG"
    bashio::log.level "debug"
fi

# Entrypoint script for Docker image of TWCManager.
# Prepare the configuration for the first time

#cp /usr/src/TWCManager/etc/twcmanager/config.json /etc/twcmanager/config.json
#chown twcmanager:twcmanager /etc/twcmanager /etc/twcmanager/config.json
cp /config.json /etc/twcmanager/config.json

# Serial enabled - set port
if bashio::config.true 'serial.enabled'; then

    serial_dev=$(bashio::config 'serial.device')
    serial_baud=$(bashio::config 'serial.baud')
    fuse_amps=$(bashio::config 'config.fuseAmps')
    phases=$(bashio::config 'config.phases')
    twc_address=$(bashio::config 'config.twc_ip')

    ## Change config file
    sed -i "s|###USBPORT_GEN3_ENABLE###|true|g" /etc/twcmanager/config.json
    bashio::log.info "Setting USB SERIAL with $serial_dev and $serial_baud..."
    sed -i "s|###USBPORT_GEN3###|$serial_dev|g" /etc/twcmanager/config.json
    sed -i "s|###USBPORT_BAUDRATE###|$serial_baud|g" /etc/twcmanager/config.json
    bashio::log.info "Setting ###FUSEAMPS### with $fuse_amps..."
    sed -i "s|###FUSEAMPS###|$fuse_amps|g" /etc/twcmanager/config.json
    sed -i "s|###PHASES###|$phases|g" /etc/twcmanager/config.json
    bashio::log.info "Setting ###IP_GEN3### with $twc_address..."
    sed -i "s|###IP_GEN3###|$twc_address|g" /etc/twcmanager/config.json

else
    sed -i "s|###USBPORT_GEN3_ENABLE###|false|g" /etc/twcmanager/config.json
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
    sed -i "s|###MQTT_ENABLED###|true|g" /etc/twcmanager/config.json
    sed -i "s|###MQTT_BROKER###|$mqtt_broker|g" /etc/twcmanager/config.json
    sed -i "s|###MQTT_PORT###|$mqtt_port|g" /etc/twcmanager/config.json
    sed -i "s|###MQTT_USER###|$mqtt_user|g" /etc/twcmanager/config.json
    sed -i "s|###MQTT_PASS###|$mqtt_pass|g" /etc/twcmanager/config.json
    sed -i "s|###MQTT_CONSUMPTION_TOPIC###|$mqtt_consumption_topic|g" /etc/twcmanager/config.json
    sed -i "s|###MQTT_GENERATION_TOPIC###|$mqtt_generation_topic|g" /etc/twcmanager/config.json
else
    bashio::log.info "MQTT disabled"
    sed -i "s|###MQTT_ENABLE###|false|g" /etc/twcmanager/config.json
fi



#cat /etc/twcmanager/config.json | grep -v "\s*#" | bashio::log.debug
#diff /config.json /etc/twcmanager/config.json
bashio::log.debug "--- Config changes: ---"
diff -u  /config.json /etc/twcmanager/config.json | while IFS= read -r linea; do
    bashio::log.debug "${linea}"
done



/usr/bin/python3 -m TWCManager 