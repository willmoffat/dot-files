export GOPATH=$HOME/go
export PATH=$HOME/bin:$GOPATH/bin:$PATH

function setEtermDir {
  echo -e "\033AnSiTu" "$LOGNAME"
  echo -e "\033AnSiTc" "$(pwd)"
  echo -e "\033AnSiTh" "$HOSTNAME"
  history -a # Write history to disk.
}
# Track directory, username, and cwd for remote logons.
if [ "$TERM" = "eterm-color" ]; then
  PROMPT_COMMAND=setEtermDir
fi

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Note(wdm): Local env not stored in git.
if [ -f ~/.bash_local ]; then
    . ~/.bash_local
fi
