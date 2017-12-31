current_dir = $(shell pwd)
keystore_path := ./validator/data/config/keystore
pwd_path := ./validator/data/config/password.txt

new-account:
	@echo "\n🌟 Creating keystore directory at $(keystore_path)\n"
	mkdir -p $(keystore_path)
ifeq ($(wildcard $(pwd_path)),)
	@read -s -p "🌟 Enter a new password to encrypt your account:" pwd; \
	echo "$$pwd" > $(pwd_path)
	@echo "\n🌟 Your password is stored at $(pwd_path)\n"
else
	@echo "\n🌟 Will encrypt your account with $(pwd_path)"
endif

	@echo "\n🌟 Pyethapp container is creating new address for you, might take few seconds:\n"
	docker build ./validator -t casper-validator
	docker run -it --rm \
	-v $(current_dir)/validator/data/config:/root/.config/pyethapp \
	-v $(current_dir)/validator/data/log:/root/log \
	casper-validator \
	pyethapp --password /root/.config/pyethapp/password.txt account new

	@echo "\n🌟 New address created at $(keystore_path)\n"
	ls $(keystore_path)

	@echo "\n🚰 You can get some test ether at http://faucet.ethereumresearch.org/ 😃"

# Defaults
bootstrap_node?=enode://d3260a710a752b926bb3328ebe29bfb568e4fb3b4c7ff59450738661113fb21f5efbdf42904c706a9f152275890840345a5bc990745919eeb2dfc2c481d778ee@54.167.247.63:30303
bootstrap_uri?=http://54.167.247.63:8545
log_config?=eth.chain:info,eth.chainservice:info,eth.validator:info
account?=1
mine_percent?=0
validator_name?=validator
# Deposit and logout commands if given
ifneq ($(strip $(deposit)),)
_deposit=--deposit ${deposit}
endif
ifeq ($(logout),true)
_logout=--logout
endif
# Join network if given
ifneq ($(strip $(network_name)),)
network=--network ${network_name}
endif

run-validator:
	docker build ./validator -t casper-validator
	@echo "\n🌟 Starting pyethapp! Happy validating!🌟\n"
	docker run -it --name ${validator_name} \
		-v $(current_dir)/validator/data/config:/root/.config/pyethapp \
		-v $(current_dir)/validator/data/log:/root/log \
		${network} \
		casper-validator \
		pyethapp -m ${mine_percent} --unlock ${account} --validate ${account} ${_deposit} ${_logout} --password /root/.config/pyethapp/password.txt -l ${log_config} --log-file /root/log/log.txt -b ${bootstrap_node} run
	docker logs -f ${validator_name}
