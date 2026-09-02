zmodload zsh/datetime

# Create a hash table for globally stashing variables without polluting main
# scope with a bunch of identifiers.
typeset -A __DOTS

__DOTS[ITALIC_ON]=$'\e[3m'
__DOTS[ITALIC_OFF]=$'\e[23m'

# ZSH only and most performant way to check existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }

# BREW_PREFIX is exported by .zprofile for login shells; derive it once here as
# a fallback so non-login interactive shells (e.g. tmux panes) work too.
exists brew && : ${BREW_PREFIX:=$(brew --prefix)}

_comp_options+=(globdots) # Include hidden files.

if exists brew; then
  fpath=("${BREW_PREFIX}/share/zsh/site-functions" $fpath)
fi

#-------------------------------------------------------------------------------
#   LOCAL SCRIPTS
#-------------------------------------------------------------------------------
# source all zsh and sh files
for ZSH_FILE in "${ZDOTDIR:-$HOME}"/scripts/*.zsh(N); do
  source "${ZSH_FILE}"
done

# Outside ZDOTDIR, which is a symlink into this repo's work tree
# After the above, so these files can call compdef
for ZSH_FILE in "${XDG_CONFIG_HOME}"/zsh-local/*.zsh(N); do
  source "${ZSH_FILE}"
done

#-------------------------------------------------------------------------------
#  RUBY
#-------------------------------------------------------------------------------
# rbenv owns the ruby version; without this its shims never land on PATH and
# `ruby` silently falls back to the EOL system 2.6.
exists rbenv && eval "$(rbenv init - --no-rehash zsh)"

#-------------------------------------------------------------------------------
#  Syntax Highlighting
#-------------------------------------------------------------------------------
# NOTE: syntax highlighting must load after all the zsh widgets are setup
# The bootstrap opens its first shell before `brew bundle` installs this
_zsh_syntax_highlighting="${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -r "$_zsh_syntax_highlighting" ]] && source "$_zsh_syntax_highlighting"
unset _zsh_syntax_highlighting
