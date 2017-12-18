
current_dir = $(shell pwd)

new-account:
	docker run -it -v $(current_dir)/keystore:/root/.config/pyethapp/keystore ethresearch/pyethapp-research:devel pyethapp account new