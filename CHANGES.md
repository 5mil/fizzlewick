# Fizzlewick changes from Bitcoin Core v31.1

Source base: https://github.com/bitcoin/bitcoin tag `v31.1`

**Positioning:** Durable test chain (not a throwaway). Strong but basic. Kept alive so tpool and other projects can run live tests instead of ephemeral regtest-only sessions.

## Applied

### 1. Poetic subsidy (required)

File: `src/validation.cpp` — function `GetBlockSubsidy`

Replaced the pure-halving logic with a single integer function:

- Base 50 * COIN  
- Triangle wave ± 20 * COIN, period 2100  
- Slow decay: base *= 19/20 every 100 000 blocks (capped)  
- Comment in plain language  
- `consensusParams` kept for call-site compatibility but unused  

The modified function is also saved as `validation.cpp.modified` in this folder for easy diff/apply.

### 2. Still required for a clean “rename” ship (do these next)

These are the classic straight-clone renames. They are mechanical and do not touch consensus machinery beyond identity.

- Binary names: bitcoind → fizzlewickd, bitcoin-cli → fizzlewick-cli  
  (CMakeLists.txt CLIENT_NAME, option strings, src/init.cpp PID file, help text)  
- Datadir default: `.bitcoin` → `.fizzlewick` (or just document `-datadir`)  
- Network magic (`pchMessageStart`) for main/test/regtest — pick four unique bytes  
- Default ports:  
  - regtest P2P 18445, RPC 18446 (recommended)  
  - main/testnet whatever does not collide  
- Genesis message: replace the Times headline with a silly wizard line  
  Example:  
  `"In the year of the flickering wick the second-rate wizard muttered a hash"`  
- Recompute / re-mine genesis nonces and update the `assert(consensus.hashGenesisBlock == ...)` lines  
  (or temporarily relax the asserts while developing)  
- Seeds / DNS seeds: clear or point at nothing for a pure local/regtest coin (or later a small public testnet)  
- Any remaining user-visible “Bitcoin” / “bitcoin” strings in RPC help, log messages, etc.

### 3. Out of scope (do not do)

- No new architecture  
- No change to sha256d, UTXO, header format, or RPC method shapes  
- No tpool changes  
- No exchange, website, or value claims  
- No exotic consensus features that would make long-term maintenance harder  

## Applying the subsidy patch quickly

```bash
# inside a fresh v31.1 tree
cp /path/to/this/validation.cpp.modified src/validation.cpp
# or use the function body from README / the prototype
```

Then build and run the LAUNCH.md steps on regtest.

## Subsidy test snippet

A tiny standalone tester that prints the schedule lives conceptually in the README table.  
Re-run the same integer logic any time to audit.

Keep the chain (and its docs) alive. Prefer small, reviewable changes.
