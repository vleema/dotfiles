# List Directory
alias ls="lsd"
alias l="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias lt="ls --tree"

# Convinient aliases
alias cfg="cd ~/.config/"
alias selan++="clang++ -Wall -std=c++20 -g"
alias v="nvim"

# Handy change dir shortcuts
abbrev-alias ..='cd ..'
abbrev-alias ...='cd ../..'
abbrev-alias .3='cd ../../..'
abbrev-alias .4='cd ../../../..'
abbrev-alias .5='cd ../../../../..'

# Always mkdir a path
abbrev-alias mkdir='mkdir -p'

# Abreviations for git
abbrev-alias gk='git checkout'
abbrev-alias gkm='git checkout main'
abbrev-alias gc='git commit'
abbrev-alias gs='git status'
abbrev-alias ga='git add'
abbrev-alias gps='git push'
abbrev-alias gpl='git pull'
abbrev-alias gl='git log'
abbrev-alias gR='git reset'
abbrev-alias gr='git restore'
abbrev-alias gd='git diff'
