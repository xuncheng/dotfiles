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

# case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
