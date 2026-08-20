# fzf key bindings + completion: ^R history search, ^T file picker, M-c cd into
# a subdirectory. `fzf --zsh` emits both halves in one shot (needs fzf >= 0.48).
#
# Loads before key-bindings.zsh alphabetically, which is fine: the keys fzf
# claims (^R/^T/M-c) do not overlap with the ones bound there.
if exists fzf; then
  source <(fzf --zsh)

  # Drive fzf's walkers with fd rather than its built-in find, so the pickers
  # follow the same defaults used elsewhere: show hidden files, skip .git.
  if exists fd; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
    export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  fi
fi
