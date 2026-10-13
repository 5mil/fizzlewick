# Fizzlewick (FIZZ)

A durable Bitcoin-family test chain kept alive for ongoing work on tpool and other projects.  
Straight clone of Bitcoin Core. **Strong, generally basic, intentionally un-fancy.**

Mined by tpool on sha256d / port 3333. Not a monetary product and not an investment.

*"Lo, another ledger of flickering wicks. Mine if you must, but mind the smoke."*  
— some second-rate ancient wizard, probably

## What this is

| Item | Value |
|------|--------|
| **Name** | Fizzlewick |
| **Ticker** | FIZZ |
| **Role** | Long-lived test / play / integration chain. We keep the network (or at least well-documented regtest + local play nets) alive so tpool, miners, and other tools have a stable target that is not mainnet Bitcoin and not a disposable one-off. |
| **PoW** | sha256d (stock miners and tpool EXTERNAL work unchanged) |
| **Architecture** | Straight clone of Bitcoin Core v31.1. UTXO, headers, RPC shape preserved. No new consensus gadgets. |
| **Datadir** | `fizzlewick` |
| **Ports (regtest)** | P2P 18445, RPC 18446 |
| **Magic bytes** | custom for FIZZ networks |

Subsidy is **not** pure halvings. See the poetic schedule below.

## Design stance

- **Strong but basic.** Reliable Bitcoin-family consensus rules, clear RPC, ordinary sha256d. Nothing exotic that would make long-term maintenance painful.
- **Perpetual for testing.** This chain (and its documented launch path) is intended to stay available. Live tests beat spinning up fresh regtest every time. Prefer small, reviewable changes over clever reinvention.
- **Transparent ledger.** Same spirit as tpool: what the node and the pool record should be understandable.
- **No value claims.** Regtest, local play, and any future public testnet are for engineering, not speculation.

## Poetic subsidy (the required spell)

One function in `src/validation.cpp` → `GetBlockSubsidy`.

- Base 50 FIZZ  
- Triangle-wave oscillation ±20 FIZZ, period 2100 blocks (a “verse”)  
- Slow integer decay (~5 % every 100 000 blocks)  
- Pure integer sats. No float consensus math.  

Sample schedule (sats):

| height | subsidy (sats) | approx FIZZ |
|--------|----------------|-------------|
| 0      | 3 000 000 000  | 30.00       |
| 1      | 3 003 809 523  | 30.38       |
| 100    | 3 380 952 380  | 33.81       |
| 500    | 4 904 761 904  | 49.48       |
| 1000   | 6 809 523 809  | 68.10       |
| 1050   | 7 000 000 000  | 70.00       |
| 1500   | 5 285 714 285  | 52.86       |
| 2100   | 3 000 000 000  | 30.00       |
| 10000  | 4 904 761 904  | 49.48       |
| 100000 | ~5.8e9         | ~58         |
| 210000 | ~2.5e9         | ~25         |

(Exact values from the function; re-print anytime by evaluating the same integer logic.)

## Build (Linux)

```bash
# Prefer a machine with normal RAM/CPU
git clone --depth 1 --branch v31.1 https://github.com/bitcoin/bitcoin.git fizzlewick
cd fizzlewick
# Apply the Fizzlewick changes (subsidy + rename + ports + genesis message)
# (see CHANGES.md or validation.cpp.modified in this folder)
cmake -B build -DBUILD_GUI=OFF -DWITH_ZMQ=OFF
cmake --build build -j$(nproc)
# binaries: build/src/bitcoind → fizzlewickd (or symlink)
#           build/src/bitcoin-cli → fizzlewick-cli
```

Windows notes: same CMake path under MSYS2 / Visual Studio, or the Guix/depends route if you already use it.

## Everyday use with tpool

See **LAUNCH.md**. That path is the everyday integration target for tpool and other tools.  
Because the chain is meant to stay up, mining and pool tests can be live instead of purely ephemeral.

## Scope

- tpool mines FIZZ via EXTERNAL RPC.  
- FIZZ does not reimplement the pool.  
- Keep the chain (and its launch docs) alive for testing.  
- No mainnet valuation claims.  
- Prefer boring, durable choices over novelty.

The wick stays lit. The hash remains.
