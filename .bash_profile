$HOME/tools/bin/say "dot bash profile"

# This file is only used when you SSH into this account.

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

if [ -f ~/.will_env ]; then
    . ~/.will_env
fi

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
