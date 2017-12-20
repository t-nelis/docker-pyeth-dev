
current_dir = $(shell pwd)
keystore_path := ./validator/data/config/keystore
pwd_path := ./validator/data/config/password.txt

new-account:
	@echo "\n🌟 Creating keystore directory at $(keystore_path)\n"
	mkdir -p $(keystore_path)
ifeq ($(wildcard $(pwd_path)),)
	@read -s -p "🌟 Enter a new password to encrypt your account:" pwd; \
	echo "$$pwd" > $(pwd_path)
	@echo "\n🌟 Your password stored at $(pwd_path)\n"
else
	@echo "\n🌟 Will encrypt your account with $(pwd_path)"
endif

	@echo "\n🌟 Pyethapp container is creating new address for you, might take few seconds:\n"
	docker run -it --rm \
	-v $(current_dir)/validator/data/config:/root/.config/pyethapp \
	ethresearch/pyethapp-research:devel \
	pyethapp --password /root/.config/pyethapp/password.txt account new

	@echo "\n🌟 New address created at $(keystore_path)\n"
	ls $(keystore_path)
