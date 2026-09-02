# Rebuild the completion dump only if it's missing or >24h old; otherwise load
# the cached one (compinit -C) to keep shell startup fast. Glob qualifiers only
# expand via filename generation (array assignment), not inside [[ ]].
# The dump goes in the cache dir: ZDOTDIR is a symlink into the dotfiles repo
autoload -Uz compinit
_zcompdump="${ZSH_CACHE_DIR:-${ZDOTDIR:-$HOME}}/zcompdump"
mkdir -p "${_zcompdump:h}"
_zcompdump_stale=( ${_zcompdump}(N.mh+24) )
if [[ ! -e "$_zcompdump" || -n "$_zcompdump_stale" ]]; then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump _zcompdump_stale

# case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
