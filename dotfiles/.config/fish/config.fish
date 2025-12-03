if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
    fastfetch
end

set -gx SHELL /usr/bin/fish
set -gx EDITOR /home/linuxbrew/.linuxbrew/bin/nvim

### bling.fish source start
test -f /usr/share/ublue-os/bling/bling.fish && source /usr/share/ublue-os/bling/bling.fish
### bling.fish source end
