echo "Running filebeat service"
service filebeat start

echo "Launching bootstrap node"
/usr/local/bin/pyethapp --unlock 3 --validate 3 -m 0 --password /root/.config/pyethapp/password.txt -l :info,eth:debug,pow:debug --log-file /root/log/log.txt run