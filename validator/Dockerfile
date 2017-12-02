FROM ethresearch/pyethapp


COPY data/config /root/.config/pyethapp
COPY data/log /root/log
COPY start.sh /root/
COPY faucet.py /root/
EXPOSE 30303
EXPOSE 30303/udp
EXPOSE 8545

ENTRYPOINT ["sh","/root/start.sh"]
