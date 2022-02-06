const fs = require('fs');
const bcoin = require('bcoin');
const KeyRing = bcoin.wallet.WalletKey;
const Script = bcoin.Script;
const network = "regtest";

const MTX = bcoin.MTX;
const Amount = bcoin.Amount;
const Coin = bcoin.Coin;

async function multiSign() {
  const s1 = fs.readFileSync("key1.wif").toString();
  const s2 = fs.readFileSync("key2.wif").toString();

  const kr1 = KeyRing.fromSecret(s1);
  const kr2 = KeyRing.fromSecret(s2);
  const receiverRing = KeyRing.fromSecret(s2);
  const receiverAddress = receiverRing.getAddress().toBase58(network);

  const m = 2;
  const n = 2;
  const redeemScript = Script.fromMultisig(m, n, [kr1.publicKey, kr2.publicKey]);
  const lockingScript = Script.fromScripthash(redeemScript.hash160());
  const multiSigAddress = lockingScript.getAddress().toBase58(network);

  // we need to create some UTXOs for ourselves to spend
  const cb = new MTX();
  cb.addInput({
    prevout: new bcoin.Outpoint(),
    script: new bcoin.Script(),
  });
  cb.addOutput({
    address: multiSigAddress,
    value: 50000,
  });

  // spend the UTXO
  const mtx = new MTX();
  const coins = [];
  const coin = Coin.fromTX(cb, 0, -1);
  coins.push(coin);

  mtx.addOutput({
    address: receiverAddress,
    value: 10000,
  });

  await mtx.fund(coins, {
    rate: 10000,
    changeAddress: multiSigAddress
  });

  kr1.script = redeemScript;
  kr2.script = redeemScript;

  mtx.scriptInput(0, coin, kr1);
  mtx.sign(kr1);
  mtx.sign(kr2);
}

multiSign().catch((err) => {
  console.err(err)
  process.exit(1);
});
