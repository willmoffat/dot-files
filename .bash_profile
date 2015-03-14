function set-eterm-dir {
  echo -e "\033AnSiTu" "$LOGNAME"
  echo -e "\033AnSiTc" "$(pwd)"
  echo -e "\033AnSiTh" "$HOSTNAME"
  history -a # Write history to disk.
}
# Track directory, username, and cwd for remote logons.
if [ "$TERM" = "eterm-color" ]; then
  PROMPT_COMMAND=set-eterm-dir
fi

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
