const bcoin = require('bcoin');
const fs = require('fs');
const KeyRing = bcoin.wallet.WalletKey;
const Script = bcoin.Script;
const network = "regtest";
const compressed = true;

const key1 = KeyRing.generate(compressed, network);
const key2 = KeyRing.generate(compressed, network);

fs.writeFileSync("key1.wif", key1.toSecret(network));
fs.writeFileSync("key2.wif", key2.toSecret(network));

// 2 of 2 multisig address
const m = 2;
const n = 2;

const pubKeys = [key1.publicKey, key2.publicKey];
const multiSigScript = Script.fromMultisig(m, n, pubKeys);

// create p2sh address
const address = multiSigScript.getAddress().toBase58(network);

fs.writeFileSync("address.txt", address);
