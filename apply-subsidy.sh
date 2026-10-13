#!/bin/bash
# Apply the Fizzlewick poetic subsidy to a Bitcoin Core v31.1 (or close) tree.
# Usage: ./apply-subsidy.sh /path/to/bitcoin-core-src
#
# Replaces the body of GetBlockSubsidy in src/validation.cpp with the
# contents of GetBlockSubsidy.snippet.cpp (or validation.cpp.modified if present).
set -e
TARGET="${1:?need path to bitcoin source tree}"
if [[ ! -f "$TARGET/src/validation.cpp" ]]; then
  echo "No src/validation.cpp under $TARGET"
  exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SNIPPET="$SCRIPT_DIR/GetBlockSubsidy.snippet.cpp"
if [[ ! -f "$SNIPPET" ]]; then
  echo "Missing $SNIPPET"
  exit 1
fi

# Simple approach: tell the human to replace the function.
# Full automated AST edit is overkill for a straight clone.
echo "Manual step (safest):"
echo "  1. Open $TARGET/src/validation.cpp"
echo "  2. Find CAmount GetBlockSubsidy(...)"
echo "  3. Replace the entire function with the body in:"
echo "       $SNIPPET"
echo "  4. Build and follow LAUNCH.md"
echo ""
echo "Snippet is ready at $SNIPPET"
