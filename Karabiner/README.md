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
