echo "Running filebeat service"
service filebeat start

CONFIG_PATH="/root/.config/pyethapp/config.yaml"
if [ -f $CONFIG_PATH ]; then
  echo "Config found! Skipping config initialization."
else
  # If the data directory does not exist, copy in defaults and generate PRIVKEY
  cp /root/default_config/config.yaml $CONFIG_PATH
  openssl rand -hex 32 > /root/.config/pyethapp/privkey.hex
  export PRIVKEY=`cat /root/.config/pyethapp/privkey.hex | awk '{print $1}'`
  echo "Generated random private key: $PRIVKEY"
  perl -pi -e "s/PRIVKEY/$PRIVKEY/" /root/.config/pyethapp/config.yaml
  echo "Initialized new validator config"
fi
echo "Running command: $@"
$@
