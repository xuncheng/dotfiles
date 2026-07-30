# Complete stored profile names for `tcb-env use|rm` and for the `tu` alias.
_tcb_env_profiles() {
  compadd -- ${(f)"$(tcb-env ls)"}
}

_tcb_env() {
  local -a subcmds
  subcmds=(add use ls rm)
  if (( CURRENT == 2 )); then
    compadd -a subcmds
  elif (( CURRENT == 3 )) && [[ $words[2] == (use|rm) ]]; then
    _tcb_env_profiles
  fi
}

if (( $+commands[tcb-env] )); then
  compdef _tcb_env tcb-env
  compdef _tcb_env_profiles tu
fi
