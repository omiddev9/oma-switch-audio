#!/usr/bin/env bash
# Basic sanity checks for the Audio Output plugin.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Checking shell syntax..."
bash -n "$SCRIPT_DIR/bin/omid-tv-audio"

echo "Checking manifest validation..."
if command -v omarchy-plugin-validate >/dev/null 2>&1; then
  omarchy-plugin-validate "$SCRIPT_DIR"
elif command -v omarchy >/dev/null 2>&1; then
  omarchy plugin validate "$SCRIPT_DIR"
else
  echo "  (omarchy not installed; skipping manifest validation)"
fi

echo "All basic checks passed."
