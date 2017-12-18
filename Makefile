
current_dir = $(shell pwd)

new-account:
	docker run -it -v $(current_dir)/keystore:/root/.config/pyethapp/keystore --entrypoint="" localethereum/pyethapp-validator pyethapp account new