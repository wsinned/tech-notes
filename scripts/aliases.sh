# misc aliases
alias ls='ls -F --color=auto --show-control-chars'
alias ll='ls -lh'
# alias la='ls -alh'
alias v='nvim'
alias vs='code'
# alias vs='code-insiders'

# git aliases
alias g='git'
alias s="git status -sbu"
alias l="git log --pretty=format:'%Cgreen%h%d %Creset%s %Cred%an, %Cgreen%ar%Creset' --graph"
alias ci="git commit"
alias ga="git add --all"


# nix aliases
# alias nix-gens="nix profile history --profile /nix/var/nix/profiles/system"


# vnc tunneling to pi4, 
# params after -l are username hostname/ip
# alias ssvnc='ssh -L 5901:127.0.0.1:5901 -C -N -l ubuntu ubuntu'

#network switcher
# alias wifi='~/scripts/network-switcher.py'

# notes_folder="$HOME/Insync/denniswoodruffuk@gmail.com/Google\ Drive/Notes"
# args="--notesFolder $notes_folder --workspace notes.code-workspace --template Home-weekly-log-template.md --batch 5"
# alias thisWeek="take-note --thisWeek $args"
# alias nextWeek="take-note --nextWeek $args"
# alias lastWeek="take-note --lastWeek $args"
