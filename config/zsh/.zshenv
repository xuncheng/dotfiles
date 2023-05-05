# vim:ft=zsh
#-------------------------------------------------------------------------------
#       ENV VARIABLES
#-------------------------------------------------------------------------------
# PATH.
# (N-/): do not register if the directory does not exists
# (Nn[-1]-/)
#
#  N   : NULL_GLOB option (ignore path if the path does not match the glob)
#  n   : Sort the output
#  [-1]: Select the last item in the array
#  -   : follow the symbol links
#  /   : ignore files
#  t   : tail of the path
# CREDIT: @ahmedelgabri
#--------------------------------------------------------------------------------
typeset -U path # ensure unique paths within PATH
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8
export EDITOR="nvim"
export ZSH_HISTORY_PATH=$HOME/.zsh_history
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

export CLICOLOR=1 # enable color support for ls.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"

export DOTFILES=${HOME}/.dotfiles

# @see: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
if which rg >/dev/null; then
  export RIPGREP_CONFIG_PATH=${DOTFILES}/config/rg/.ripgreprc
fi

# @see: https://github.com/sharkdp/bat#configuration-file
if which bat >/dev/null; then
  export BAT_CONFIG_PATH=${DOTFILES}/config/bat/config
fi

#
# [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
#
# NOTE: for signing commits with GPG
export GPG_TTY=$(tty)

path+=(
  /usr/local/bin
  ${HOME}/.npm/bin(N-/)
  ${HOME}/.bin(N-/)
  ${HOME}/.local/bin(N-/)
  # Add local build of neovim to path for development
  ${HOME}/nvim/bin(N-/)
  ${HOME}/.rvm/bin(N-/)
  ${HOME}/.volta/bin(N-/)
  # package manager for neovim
  ${HOME}/.local/share/bob/nvim-bin(N-/)
)
