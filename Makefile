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
	docker run -it --rm \
	-v $(current_dir)/validator/data/config:/root/.config/pyethapp \
	-v $(current_dir)/validator/data/log:/root/log \
	ethresearch/pyethapp-research:devel \
	pyethapp --password /root/.config/pyethapp/password.txt account new

	@echo "\n🌟 New address created at $(keystore_path)\n"
	ls $(keystore_path)

	@echo "\n🚰 You can get some test ether at http://faucet.ethereumresearch.org/ 😃"

# Defaults
bootstrap_node?=enode://d3260a710a752b926bb3328ebe29bfb568e4fb3b4c7ff59450738661113fb21f5efbdf42904c706a9f152275890840345a5bc990745919eeb2dfc2c481d778ee@54.167.247.63:30303
bootstrap_uri?=http://54.167.247.63:8545
rpc_port?=8545
devp2p_port?=30303
# Node names
validator_name?=validator
miner_name?=miner
bootstrap_name?=bootstrap

run-validator:
	docker build ./validator -t casper-validator
	docker run -d --name ${validator_name} \
		-p ${rpc_port}:8545 -p ${devp2p_port}:30303 -p ${devp2p_port}:30303/udp \
		-e BOOTSTRAP_NODE="${bootstrap_node}" -e BOOTSTRAP_NODE_URI="${bootstrap_uri}" \
		-v $(current_dir)/validator/data/config:/root/.config/pyethapp \
		-v $(current_dir)/validator/data/log:/root/log \
		casper-validator
	docker logs -f ${validator_name}

logout-validator:
	docker build ./validator -t casper-validator
	# TODO: Fix this up

run-miner:
	docker build ./miner -t casper-miner
	docker run -d --name ${miner_name} \
		-p ${rpc_port}:8545 -p ${devp2p_port}:30303 -p ${devp2p_port}:30303/udp \
		-e BOOTSTRAP_NODE="${bootstrap_node}" -e BOOTSTRAP_NODE_URI="${bootstrap_uri}" \
		casper-miner
	docker logs -f ${miner_name}

run-bootstrap:
	docker build ./bootstrap -t casper-bootstrap
	docker run -d --name ${bootstrap_name} \
		-p ${rpc_port}:8545 -p ${devp2p_port}:30303 -p ${devp2p_port}:30303/udp \
		casper-bootstrap
	docker logs -f ${bootstrap_name}
