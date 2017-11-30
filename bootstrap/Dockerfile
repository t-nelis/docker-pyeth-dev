FROM ethresearch/pyethapp

COPY data/config /root/.config/pyethapp
COPY data/log /root/log
EXPOSE 30303
EXPOSE 30303/udp
EXPOSE 8545

ENTRYPOINT ["/usr/local/bin/pyethapp", "--unlock", "3", "--validate", "3", "-m", "0", "--password", "/root/.config/pyethapp/password.txt", "-l", ":info,eth:debug,pow:debug", "--log-file", "/root/log/log.txt", "run"]
