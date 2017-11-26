FROM ubuntu:16.04
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install system dependencies
RUN apt-get update
RUN apt-get install -y software-properties-common vim git git-core iputils-ping
RUN add-apt-repository -y ppa:jonathonf/python-3.6
RUN add-apt-repository -y ppa:ethereum/ethereum
RUN apt-get update
RUN apt-get install -y solc
RUN apt-get install -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv
RUN apt-get install -y libssl-dev build-essential automake pkg-config libtool libffi-dev libgmp-dev
RUN apt-get install -y git

# Install Python dependencies
RUN python3.6 -m pip install pip --upgrade
RUN python3.6 -m pip install wheel
RUN ln -sf /usr/local/bin/pip3.6 /usr/local/bin/pip \
    && ln -sf /usr/bin/python3.6 /usr/local/bin/python \
    && pip install -U pip
RUN pip install coincurve==6.0.0

# Clone and install (editable) required repositories
RUN mkdir /ethereum
WORKDIR /ethereum
RUN git clone https://github.com/ethereum/viper.git
RUN git clone  --recursive https://github.com/karlfloersch/pyethereum.git
RUN git clone https://github.com/karlfloersch/pyethapp.git
RUN cd viper && python setup.py develop
RUN cd pyethapp && python setup.py develop
RUN cd pyethereum && python setup.py develop

COPY data/config /root/.config/pyethapp
COPY data/log /root/log
COPY start.sh /root/
EXPOSE 30303
EXPOSE 30303/udp
EXPOSE 8545

ENTRYPOINT ["sh","/root/start.sh"]