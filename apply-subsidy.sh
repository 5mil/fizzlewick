#!/bin/bash
# Apply the Fizzlewick poetic subsidy to a Bitcoin Core v31.1 (or close) tree.
# Usage: ./apply-subsidy.sh /path/to/bitcoin-core-src
set -e
TARGET="${1:?need path to bitcoin source tree}"
if [[ ! -f "$TARGET/src/validation.cpp" ]]; then
  echo "No src/validation.cpp under $TARGET"
  exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/validation.cpp.modified" "$TARGET/src/validation.cpp"
echo "Replaced GetBlockSubsidy in $TARGET/src/validation.cpp"
echo "Next: do the rename/ports/genesis steps in CHANGES.md, then build."
