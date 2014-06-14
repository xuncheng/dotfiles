autoload -U compinit
compinit

_ack() {
  if (( CURRENT == 2 )); then
    if [[ -a tmp/tags || -a .git/tags ]]; then
      compadd $(parse_tags)
    fi
  else;
    _files
  fi
}

compdef _ack ack
compdef _ack ag
