# My Personal Tech Notes

- Arch Linux Installation
- dotfiles


## Kanshi

For the NanoKVM setup, link or copy `dotfiles/.config/kanshi/config` to
`$XDG_CONFIG_HOME/kanshi/config` (usually `~/.config/kanshi/config`) before
starting Niri. The NanoKVM profile runs `~/.config/scripts/nanokvm-mirror`
after it is applied. The NixOS Home Manager profile links `dotfiles/scripts`
to `~/.config/scripts`. On other setups, link the directory or install the
helper at that path.
