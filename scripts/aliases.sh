# misc aliases
alias ls='ls -F --color=auto --show-control-chars'
alias ll='ls -lh'
alias la='ls -alh'
alias v='nvim'
# alias vs='code-insiders'
alias vs='code'
# alias notes='code ~/OneDrive/Writing'

# git aliases
alias g='git'
alias s="git status -sbu"
alias l="git log --pretty=format:'%Cgreen%h%d %Creset%s %Cred%an, %Cgreen%ar%Creset' --graph"
alias ci="git commit"
alias ga="git add --all"


# vnc tunneling to pi4, 
# params after -l are username hostname/ip
# alias ssvnc='ssh -L 5901:127.0.0.1:5901 -C -N -l ubuntu ubuntu'

#network switcher
# alias wifi='~/scripts/network-switcher.py'

if [[ -f ~/scripts/python/createNotes.py ]]; then
    alias thisWeek="python ~/scripts/python/createNotes.py --thisWeek"
    alias nextWeek="python ~/scripts/python/createNotes.py --nextWeek"
    alias lastWeek="python ~/scripts/python/createNotes.py --lastWeek"
fi
