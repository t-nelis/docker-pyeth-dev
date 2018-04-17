echo "Running filebeat service"
service filebeat start
echo "BOOTSTRAP_NODE is $BOOTSTRAP_NODE"
if [ -z "$BOOTSTRAP_NODE" ]; then echo "BOOTSTRAP_NODE must be set" && exit 1; fi
openssl rand -hex 32 > /root/.config/pyethapp/privkey.hex
export PRIVKEY=`cat /root/.config/pyethapp/privkey.hex | awk '{print $1}'`
echo "Generated random private key: $PRIVKEY" 
perl -pi -e "s/PRIVKEY/$PRIVKEY/" /root/.config/pyethapp/config.yaml
echo "Creating new account"
/usr/local/bin/pyethapp --password /root/.config/pyethapp/password.txt account new
sleep $SLEEPTIME
echo "Launching node with mine amt: $MINE_PERCENT"
exec /usr/local/bin/pyethapp -m $MINE_PERCENT -l eth.chain:info,eth.chainservice:info,eth.validator:info --log-file /root/log/log.txt -b $BOOTSTRAP_NODE run
