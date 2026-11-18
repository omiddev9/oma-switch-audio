#!/usr/bin/env bash
# uninstall.sh — Remove the Audio Output (oma-switch-audio) Omarchy plugin.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ID="io.github.omiddev9.oma-switch-audio"
BIN_NAME="omaaudio"

echo "Uninstalling Audio Output ($PLUGIN_ID)..."

if command -v omarchy >/dev/null 2>&1; then
  omarchy plugin disable "$PLUGIN_ID" 2>/dev/null || true
fi

rm -f "$HOME/.local/bin/$BIN_NAME"

PLUGIN_TARGET="$HOME/.config/omarchy/plugins/$PLUGIN_ID"
if [[ -L "$PLUGIN_TARGET" ]]; then
  rm -f "$PLUGIN_TARGET"
elif [[ -d "$PLUGIN_TARGET" ]]; then
  if [[ "$(cd "$PLUGIN_TARGET" && pwd -P)" == "$(cd "$SCRIPT_DIR" && pwd -P)" ]]; then
    echo "Plugin directory is the source checkout; leaving it in place."
  else
    echo "Leaving plugin directory in place (not a symlink): $PLUGIN_TARGET"
  fi
fi

rm -rf "$HOME/.local/state/oma-switch-audio"

if command -v omarchy-shell >/dev/null 2>&1; then
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
fi

echo "✓ Audio Output uninstalled."
echo "  Remove the plugin directory manually if you cloned it somewhere else."
