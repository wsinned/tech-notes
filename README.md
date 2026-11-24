# My Personal Tech Notes

- Arch Linux Installation
- dotfiles


## Kanshi

For the NanoKVM setup, link or copy `dotfiles/.config/kanshi/config` to
`$XDG_CONFIG_HOME/kanshi/config` (usually `~/.config/kanshi/config`) before
starting Niri. The NanoKVM profile calls the local helper
`~/.local/bin/nanokvm-mirror` after the profile is applied.
