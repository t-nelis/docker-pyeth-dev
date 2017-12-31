# pyethapp development environment containers

Get multiple pyethapp nodes running in no time!

## Dependencies
- `docker`
- `docker-compose`

## Setup Local Testnet
First start up the default bootstrap node & miner with:
```
$ docker-compose build
$ docker-compose up
```

Next generate a new account with:
```
$ make new-account
```

Then send yourself some ETH with the faucet_util.py
```
$ docker exec -it bootstrap bash
$ # Logs into docker container
$$ python $FAUCET_PRIV_KEY $YOUR_ADDRESS $localhost
$$ # Check that the transaction worked with
$$ python
> from web3 import Web3, HTTPProvider
> provider_uri = 'http://0.0.0.0:8545'
> web3 = Web3(HTTPProvider(provider_uri))
> web3.eth.getBalance($YOUR_ADDRESS)
50000000000000000000  # Yay!
```

Finally, login to the network with your validator
```
$ make run-validator deposit=5000 network=dockerpyethdev_back bootstrap_node=enode://d3260a710a752b926bb3328ebe29bfb568e4fb3b4c7ff59450738661113fb21f5efbdf42904c706a9f152275890840345a5bc990745919eeb2dfc2c481d778ee@172.18.250.2:30303
```

You can then stop your validator, and logout with
```
$ make run-validator logout=true network=dockerpyethdev_back bootstrap_node=enode://d3260a710a752b926bb3328ebe29bfb568e4fb3b4c7ff59450738661113fb21f5efbdf42904c706a9f152275890840345a5bc990745919eeb2dfc2c481d778ee@172.18.250.2:30303
```
