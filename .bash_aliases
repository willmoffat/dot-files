# ;; -*- mode: shell-script; -*-

# Config Dotfiles in Git.
alias cf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias cfs='cf status'
alias cfd='cf diff'

alias gs='git status'
alias gd='git diff'
alias gb='git branch'

if command -v nautilus >/dev/null 2>&1; then
   alias o='nautilus 2>/dev/null'
else
   alias o='gnome-open'
fi

# Send file to emacs, starting in daemon mode if necessary.
alias e='TERM=xterm-256color emacsclient -nw --alternate-editor=""'

# If this is an emacs terminal then don't start emacs in emacs frame.
case "$TERM" in
eterm*)
    alias e='emacsclient'
    ;;
*)
    ;;
esac

# Serial port screen.
alias ss='screen /dev/ttyUSB* 115200'
