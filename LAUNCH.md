# Fizzlewick LAUNCH

Primary path: **regtest / local play**.  
This chain is kept alive as a stable testing target for tpool and other projects. Label environments clearly (regtest, local play, any future public testnet).

Advantage of a perpetual test chain: mining, share, maturity, and payout tests can stay live instead of being re-spun from scratch every session.

## 1. Conf

Create `~/.fizzlewick/fizzlewick.conf` (or pass `-datadir=...`):

```
regtest=1
server=1
rpcuser=fizz
rpcpassword=wick-of-the-ancients
rpcport=18446
port=18445
daemon=1
txindex=1
fallbackfee=0.0001
```

(RPC port 18446, P2P 18445 — keep clear of Bitcoin’s defaults.)

## 2. Start the node

```bash
# after build, or with renamed binary
./fizzlewickd -datadir=$HOME/.fizzlewick -conf=$HOME/.fizzlewick/fizzlewick.conf

# or if still named bitcoind:
./bitcoind -datadir=$HOME/.fizzlewick -conf=$HOME/.fizzlewick/fizzlewick.conf -regtest
```

Check:

```bash
./fizzlewick-cli -datadir=$HOME/.fizzlewick getblockchaininfo
```

## 3. Wallet + address + mine

```bash
./fizzlewick-cli -datadir=$HOME/.fizzlewick createwallet "wizard"
ADDR=$(./fizzlewick-cli -datadir=$HOME/.fizzlewick getnewaddress)
echo "mine to: $ADDR"

# mine a few blocks (regtest is instant)
./fizzlewick-cli -datadir=$HOME/.fizzlewick generatetoaddress 10 "$ADDR"
./fizzlewick-cli -datadir=$HOME/.fizzlewick getbalance
```

Subsidy at low heights follows the poetic curve (starts ~30 FIZZ, climbs toward 70 around height 1050, then back down).

## 4. Point tpool at it (EXTERNAL)

In tpool config / operator docs, use:

```
http://fizz:wick-of-the-ancients@127.0.0.1:18446
```

Example EXTERNAL line (exact shape depends on tpool’s current EXTERNAL RPC helper):

```
EXTERNAL=http://fizz:wick-of-the-ancients@127.0.0.1:18446
```

tpool talks ordinary Bitcoin-style RPC (`getblocktemplate`, `submitblock`, etc.). Because PoW is still sha256d, any stock sha256d miner or tpool’s own path on port 3333 can point at the stratum side once the node is giving work.

## 5. One-page params

| Item          | Value                                      |
|---------------|--------------------------------------------|
| Name          | Fizzlewick                                 |
| Ticker        | FIZZ                                       |
| Role          | Long-lived test / integration chain        |
| PoW           | sha256d                                    |
| P2P (regtest) | 18445                                      |
| RPC (regtest) | 18446                                      |
| Datadir       | fizzlewick                                 |
| Subsidy       | base 50 FIZZ ±20 triangle wave (period 2100) + slow integer decay; see GetBlockSubsidy |

## 6. Verify subsidy matches the rule

Mine a block, then:

```bash
./fizzlewick-cli -datadir=$HOME/.fizzlewick getblock $(./fizzlewick-cli -datadir=$HOME/.fizzlewick getbestblockhash) 1 | jq '.tx[0]'
```

Or compare coinbase value against the printed schedule in README.

## Done when

- Node runs on regtest  
- `generatetoaddress` works  
- Subsidy follows the integer poetic function  
- tpool can be pointed at the RPC URL above  
- A sha256d miner can attach via tpool stratum (port 3333)  
- Launch path is documented and repeatable so the chain stays usable as a permanent test target  

The ancient wizard keeps the wick trimmed. The ledger stays open for testing.
