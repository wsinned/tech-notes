function l
    git log --pretty=format:'%C(yellow)%h %C(reset)%ad %C(blue)%an%C(green)%d %C(reset)%s' --date=relative --graph $argv
end
