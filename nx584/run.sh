#!/usr/bin/with-contenv bashio

bashio::log.info $(cat /etc/os-release)
bashio::log.info "Preparing to start..."

# To-DO Build /data/config.ini dynamically taking config files
config=$(bashio::config 'config')
bashio::log.info "LOG: $config"

cp config.ini_template /usr/app/src/config.ini 
config_max_zone=$(bashio::config 'config.max_zone')
sed -i "s/###MAX_ZONE###/$config_max_zone/g" /usr/app/src/config.ini 
if bashio::config.true 'config.zone_name_update'; then
  sed -i 's/###ZONE_NAME_UPDATE###/True/g' /usr/app/src/config.ini 
else
  sed -i 's/###ZONE_NAME_UPDATE###/False/g' /usr/app/src/config.ini 
fi
if bashio::config.true 'config.euro_date_format'; then
  sed -i 's/###EURO_DATE_FORMAT###/True/g' /usr/app/src/config.ini 
else
  sed -i 's/###EURO_DATE_FORMAT###/False/g' /usr/app/src/config.ini 
fi
if bashio::config.true 'config.use_binary_protocol'; then
  sed -i 's/###USE_BINARY_PROTOCOL###/True/g' /usr/app/src/config.ini 
else
  sed -i 's/###USE_BINARY_PROTOCOL###/False/g' /usr/app/src/config.ini 
fi
idle_time_heartbeat_seconds=$(bashio::config 'config.idle_time_heartbeat_seconds')
sed -i "s/###IDLE_TIME_HEARTBEAT###/${idle_time_heartbeat_seconds}/g" /usr/app/src/config.ini 
ZONES="$(bashio::config 'config.zones')"


# Script to split a string based on the delimiter
IFS=',' read -ra my_array <<< "$ZONES"
count=1
for item in "${my_array[@]}"
do
  echo "$count = $item" >> /usr/app/src/config.ini 
  count=$((count + 1))
done

bashio::log.info "---"
bashio::log.info "$(cat /usr/app/src/config.ini )"
bashio::log.info "---"

DEBUG=""
if bashio::config.true 'debug_enabled'; then
  bashio::log.info " * DEBUG Mode ON..."
  DEBUG="--debug "
fi


# Serial
if bashio::config.true 'serial.enabled'; then
    bashio::log.info "Serial enabled"
    ## Get variables from the user config options.
    serial_dev=$(bashio::config 'serial.device')
    serial_baud=$(bashio::config 'serial.baud')

    ## Start nx server using serial Interface
    bashio::log.info "Starting NX584 Server on Serial interface..."
    python3 /usr/bin/nx584_server  --listen 0.0.0.0 --port 5007 --serial $serial_dev --baud $serial_baud --config /usr/app/src/config.ini $DEBUG

elif bashio::config.true 'socat.enabled'; then
    bashio::log.info "socat enabled"
    ## Get variables from the user config options.
    socat_host=$(bashio::config 'socat.host')
    socat_port=$(bashio::config 'socat.port')

    ## Start nx server using socat interface
    python3 /usr/bin/nx584_server --listen 0.0.0.0 --port 5007 --connect ${socat_host}:${socat_port} --config /usr/app/src/config.ini $DEBUG
fi

