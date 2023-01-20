# ;; -*- mode: shell-script; -*-
"$HOME/tools/bin/say" "dot bash aliases"

# Config Dotfiles in Git.
alias cf='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias cfs='cf status'
alias cfd='cf diff'

alias gs='git status'
alias gd='git diff'
alias gdm='git diff --stat master'
alias gb='git branch'
alias gr='cd "$(git rev-parse --show-toplevel)"'

alias www='busybox httpd -p 8000 -f -vv'

if   command -v nautilus   &> /dev/null; then alias o='nautilus 2>/dev/null'
elif command -v thunar     &> /dev/null; then alias o='thunar 2>/dev/null'
elif command -v gnome-open &> /dev/null; then alias o='gnome-open 2>/dev/null'
fi

# Open specified file in exisiting emacs.
alias e='emacsclient'

# Serial port screen.
alias s0='screen /dev/ttyUSB0 115200'
alias s1='screen /dev/ttyUSB1 115200'
alias s2='screen /dev/ttyUSB2 115200'

# systemd
alias c='sudo systemctl'

# Android
alias expo-dev-menu='adb shell input keyevent 82'

# Note(wdm): Local aliases not stored in git.
if [ -f "$HOME/.bash_aliases_local" ]; then
    . "$HOME/.bash_aliases_local"
fi

# Google workspace admin
function gam() { "$HOME/bin/gam/gam" "$@" ; }
