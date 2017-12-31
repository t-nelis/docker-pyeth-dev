KEYSTORE_PATH=$1
PWD_PATH=$2
CURRENT_DIR=$3

printf "\n🌟 Creating keystore directory at $KEYSTORE_PATH\n"
mkdir -p $KEYSTORE_PATH
if [ ! -f $PWD_PATH ]; then
    echo -n "🌟 Enter a new password to encrypt your account:"
    read -s pwd;
    printf "$pwd" > $PWD_PATH
    printf "\n🌟 Your password is stored at $PWD_PATH\n"
else
    printf "\n🌟 Will encrypt your account with $PWD_PATH"
fi

printf "\n🌟 Pyethapp container is creating new address for you, might take few seconds:\n"
docker build ./validator -t casper-validator
docker run -it --rm \
    -v $CURRENT_DIR/validator/data/config:/root/.config/pyethapp \
    -v $CURRENT_DIR/validator/data/log:/root/log \
    casper-validator \
    pyethapp --password /root/.config/pyethapp/password.txt account new

printf "\n🌟 New address created at $KEYSTORE_PATH\n"
ls $KEYSTORE_PATH