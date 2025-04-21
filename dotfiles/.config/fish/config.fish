if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx SHELL /usr/bin/fish
### bling.fish source start
test -f /usr/share/ublue-os/bling/bling.fish && source /usr/share/ublue-os/bling/bling.fish
### bling.fish source end

abbr la eza -l --all --icons=auto --group-directories-first
abbr g git
abbr s git status -sbu
abbr l git log --pretty=format:'"%C(yellow)%h %C(reset)%ad %C(blue)%an%C(green)%d %C(reset)%s"' --date=relative --graph
abbr ci git commit
abbr ga git add --all
