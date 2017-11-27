from web3 import Web3, HTTPProvider
from ethereum.transactions import Transaction
from ethereum.utils import privtoaddr, encode_hex
import os, json, rlp, time

print('Generating faucet tx')

keystore_path = '/root/.config/pyethapp/keystore/'
keystore_files = os.listdir(keystore_path)
assert len(keystore_files) == 1
keystore = json.load(open(os.path.join(keystore_path, keystore_files[0])))

faucetPrivkey = os.environ['FAUCET_PRIVKEY']
faucetAddress = encode_hex(privtoaddr(faucetPrivkey))
recipAddress = keystore['address']

web3 = Web3(HTTPProvider(os.environ['BOOTSTRAP_NODE_URI']))

nonce = web3.eth.getTransactionCount(faucetAddress)
tx = Transaction(nonce, 25*10**9, 21*10**3, recipAddress, 5000*10**19, '').sign(faucetPrivkey)
txraw = rlp.hex_encode(tx)
print('Transaction generated')
if 'SLEEPTIME' in os.environ:
    sleeptime = os.environ['SLEEPTIME']
    print('Going to sleep for ' + sleeptime + ' seconds')
    time.sleep(int(sleeptime))
    print('Waking up and broadcasting transaction')
txid = web3.eth.sendRawTransaction(txraw)
assert txid
print('Transmitted faucet transaction: ' + txid)

