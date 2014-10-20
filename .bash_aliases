alias gs='git status'
alias gd='git diff'

# Send file to emacs, starting in daemon mode if necessary.
alias e='emacsclient -nw --alternate-editor=""'

# If this is an emacs terminal then don't start emacs in emacs frame.
case "$TERM" in
eterm*)
    alias e='emacsclient'
    ;;
*)
    ;;
esac



