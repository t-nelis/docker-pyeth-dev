
current_dir = $(shell pwd)
keystore_path := ./validator/data/keystore
pwd_path := ./validator/data/config/password.txt

new-account:
	@echo "\n🌟 Creating keystore directory at $(keystore_path)\n"
	mkdir -p $(keystore_path)

	@read -s -p "🌟 Enter a new password to encrypt your account:" pwd; \
	echo "$$pwd" > $(pwd_path)
	@echo "\n🌟 Your password stored at $(pwd_path)\n"

	@echo "\n🌟 Pyethapp container is creating new address for you, might take few seconds:\n"
	docker run -it --rm \
	-v $(current_dir)/$(pwd_path):/root/.config/pyethapp/password.txt \
	-v $(current_dir)/$(keystore_path):/root/.config/pyethapp/keystore \
	ethresearch/pyethapp-research:devel \
	pyethapp --password /root/.config/pyethapp/password.txt account new

	@echo "\n🌟 New address created at $(keystore_path)\n"
	ls $(keystore_path)