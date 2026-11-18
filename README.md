# Audio Output

An [Omarchy](https://omarchy.org) shell plugin that follows whichever audio
output you plug in: a headphone/jack speaker, a Bluetooth or USB device, the
HDMI display, or the built-in laptop speakers.

The built-in HDA card only runs one output profile at a time (analog **or**
HDMI), so PipeWire does not even create the other sink until the card profile is
changed. The stock Omarchy audio picker cannot do that on its own; this plugin
switches the card profile for you.

## Features

- Automatic routing to the most recently connected output.
- Manual cycling through the outputs that are actually connected.
- Bar widget showing the output that currently owns the audio.
- CLI (`omaaudio`) for keybindings and terminal use (legacy `omid-tv-audio`
  launcher kept for compatibility).
- Remembers your choice across reboots.

## Requirements

- Omarchy with its shell running.
- PipeWire/PulseAudio (`pactl`).
- `alsa-utils` (`amixer`) for headphone-jack detection.
- `util-linux` (`flock`) for safe concurrent access.
- `libnotify` (`notify-send`) is optional, for desktop notifications.

## Install

```bash
git clone https://github.com/omiddev9/oma-switch-audio.git
cd oma-switch-audio
./install.sh
```

Or, using Omarchy's plugin manager:

```bash
omarchy plugin add https://github.com/omiddev9/oma-switch-audio.git --enable
cd ~/.config/omarchy/plugins/omid.tv-audio
./install.sh
```

The installer links the plugin into `~/.config/omarchy/plugins/`, installs the
`omaaudio` launcher into `~/.local/bin/`, and enables the bar widget.

## Usage

```bash
omaaudio status     # report the current output
omaaudio list       # list available outputs
omaaudio toggle     # cycle to the next connected output
omaaudio follow     # return to automatic (last-plugged) routing
omaaudio auto       # re-evaluate and apply automatically
```

Bar widget:

- Left click: cycle to the next output.
- Right click: return to automatic routing.
- Middle click: open Omarchy's audio panel.

## Keybinding

Add to `~/.config/hypr/bindings.conf` (or your Omarchy bindings file):

```
bind = $mainMod, A, exec, omaaudio toggle
```

## Uninstall

```bash
./uninstall.sh
```

## License

MIT
```

Also update line 17. Let's edit.<|end|><|start|>Assistant to=edit<|channel|>analysis <|constrain|>xml<|message|><rfl:parameter name="path">
/home/omid/Work/omaaudio/README.md