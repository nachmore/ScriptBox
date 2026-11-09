# Nachmore's Keyboard (Karabiner-Elements)

Minimal Windows-style keys for macOS:

- **Ctrl+Left/Right** jump by word (Shift selects)
- **Home/End** go to start/end of line (Shift selects); **Ctrl+Home/End** go to start/end of document
- **Shift+Insert** pastes
- **Ctrl+Cmd+Home / PgUp / PgDn** play/pause, previous track, next track

`karabiner.json` is the live config. `assets/complex_modifications/nachmores-keyboard.json` holds the same rules for importing via *Complex Modifications → Add predefined rule*.

## Setup

Symlink the whole directory (Karabiner doesn't detect changes if `karabiner.json` itself is a symlink):

```sh
mv ~/.config/karabiner ~/.config/karabiner.bak
ln -s ~/oss/ScriptBox/Karabiner ~/.config/karabiner
launchctl kickstart -k gui/$(id -u)/org.pqrs.service.agent.Karabiner-Console-User-Server
```

Changes made in Karabiner Settings are written here and show up in `git status`.

## Logitech ERGO K860

In Mac mode the K860 never sends Insert (it doesn't show up in Karabiner-EventViewer at all), so Shift+Insert can't work. The workaround:

1. Put the keyboard in **Windows mode**: hold **fn+P** for 3 seconds (fn+O switches back to Mac mode).
2. `karabiner.json` has a device entry for the K860 (`vendor_id` 1133, `product_id` 45924) that:
   - turns on **Modify events**. Karabiner ignores this keyboard by default because it also reports itself as a pointing device.
   - swaps the modifiers back to their Mac positions: **Win → Option**, **Alt → Cmd**, **AltGr → Cmd**.

Caveats:

- The swap is always on for this keyboard. In Mac mode, Option and Cmd will be the wrong way round.
- Some special keys (Task View, Lock, Print Screen, Menu) send Windows shortcuts in Windows mode and aren't remapped yet.
- While Karabiner modifies the K860, **OpenLogi** can't connect to it (no battery/lock-key notifications or keyboard settings). To use OpenLogi again, turn off *Modify events* for the K860 in Karabiner Settings → Devices.
