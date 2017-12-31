from web3 import Web3, HTTPProvider
from ethereum.transactions import Transaction
from ethereum.utils import privtoaddr, encode_hex
import sys
import rlp

print('Generating faucet tx')

faucetPrivkey = '87f97f6a4d97ab0d26c2949fb6456bc3961e339502be389cb284aa0b67f8b2bf'
faucetAddress = encode_hex(privtoaddr(faucetPrivkey))
recipAddress = sys.argv[1]
provider_uri = 'http://' + sys.argv[2] + ':8545'

web3 = Web3(HTTPProvider(provider_uri))

nonce = web3.eth.getTransactionCount(faucetAddress)
tx = Transaction(nonce, 25*10**9, 21*10**3, recipAddress, 5000*10**19, '').sign(faucetPrivkey)
txraw = rlp.hex_encode(tx)
print('Transaction generated')
txid = web3.eth.sendRawTransaction(txraw)
assert txid
print('Transmitted faucet transaction: ' + txid)
