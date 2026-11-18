#!/usr/bin/env bash
# install.sh — Install the Audio Output (oma-switch-audio) Omarchy plugin.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ID="io.github.omiddev9.oma-switch-audio"
BIN_NAME="omaaudio"

echo "============================================================"
echo " Installing Audio Output ($PLUGIN_ID)"
echo "============================================================"

mkdir -p "$HOME/.config/omarchy/plugins"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/state"

PLUGIN_TARGET="$HOME/.config/omarchy/plugins/$PLUGIN_ID"
if [[ -L "$PLUGIN_TARGET" ]]; then
  if [[ "$(readlink -f "$PLUGIN_TARGET" 2>/dev/null || true)" == "$SCRIPT_DIR" ]]; then
    echo "✓ Plugin link already points to $SCRIPT_DIR"
  else
    echo "Replacing stale plugin link..."
    rm -f "$PLUGIN_TARGET"
    ln -s "$SCRIPT_DIR" "$PLUGIN_TARGET"
  fi
elif [[ -d "$PLUGIN_TARGET" ]]; then
  if [[ "$(cd "$PLUGIN_TARGET" && pwd -P)" == "$(cd "$SCRIPT_DIR" && pwd -P)" ]]; then
    echo "✓ Plugin already installed in place"
  else
    echo "A different plugin directory already exists at $PLUGIN_TARGET."
    echo "  Leaving it untouched; remove it manually if you want to relink."
  fi
else
  echo "Linking plugin into $PLUGIN_TARGET..."
  ln -s "$SCRIPT_DIR" "$PLUGIN_TARGET"
fi

echo "Installing CLI launcher to ~/.local/bin/..."
BIN_TARGET="$HOME/.local/bin/$BIN_NAME"
if [[ -L "$BIN_TARGET" || -e "$BIN_TARGET" ]]; then
  existing="$(readlink -f "$BIN_TARGET" 2>/dev/null || true)"
  if [[ "$existing" == "$SCRIPT_DIR/bin/$BIN_NAME" ]]; then
    echo "✓ $BIN_TARGET already points to this plugin"
  else
    echo "⚠ $BIN_TARGET exists and is not managed by this plugin; leaving it untouched."
    echo "  Remove or rename it if you want the omaaudio launcher."
  fi
else
  ln -s "$SCRIPT_DIR/bin/$BIN_NAME" "$BIN_TARGET"
  echo "✓ $BIN_TARGET"
fi
chmod +x "$SCRIPT_DIR/bin/$BIN_NAME"

if command -v omarchy-plugin-validate >/dev/null 2>&1; then
  echo "Validating plugin manifest..."
  omarchy-plugin-validate "$SCRIPT_DIR" || echo "Note: manifest validation warning"
elif command -v omarchy >/dev/null 2>&1; then
  omarchy plugin validate "$SCRIPT_DIR" || echo "Note: manifest validation warning"
fi

if command -v omarchy >/dev/null 2>&1; then
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
  echo "Enabling plugin in the Omarchy shell..."
  omarchy plugin enable "$PLUGIN_ID" 2>/dev/null || true
fi

echo ""
echo "============================================================"
echo " ✓ Installation complete!"
echo "============================================================"
echo "Available outputs are detected automatically."
echo ""
echo "Usage:"
echo "  omaaudio status          # show the current output"
echo "  omaaudio toggle          # cycle to the next connected output"
echo "  omaaudio follow          # return to automatic (last-plugged) routing"
echo ""
echo "The bar widget cycles outputs on left click and returns to automatic"
echo "routing on right click. Middle click opens Omarchy's audio panel."
echo ""
echo "Optional Hyprland keybinding (~/.config/hypr/bindings.conf):"
echo "  bind = \$mainMod, A, exec, omaaudio toggle"
echo ""
echo "Dependencies: PipeWire/PulseAudio (pactl), alsa-utils (amixer),"
echo "util-linux (flock), and libnotify (notify-send, optional)."
echo "============================================================"
