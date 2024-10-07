zmodload zsh/datetime

# Create a hash table for globally stashing variables without polluting main
# scope with a bunch of identifiers.
typeset -A __DOTS

__DOTS[ITALIC_ON]=$'\e[3m'
__DOTS[ITALIC_OFF]=$'\e[23m'

# ZSH only and most performant way to check existence of an executable
# https://www.topbug.net/blog/2016/10/11/speed-test-check-the-existence-of-a-command-in-bash-and-zsh/
exists() { (( $+commands[$1] )); }

_comp_options+=(globdots) # Include hidden files.

if exists brew; then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

#-------------------------------------------------------------------------------
#   LOCAL SCRIPTS
#-------------------------------------------------------------------------------
# source all zsh and sh files
for ZSH_FILE in "${ZDOTDIR:-$HOME}"/scripts/*.zsh(N); do
  source "${ZSH_FILE}"
done

#-------------------------------------------------------------------------------
#  Syntax Highlighting
#-------------------------------------------------------------------------------
# NOTE: syntax highlighting must load after all the zsh widgets are setup
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/xuncheng/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/xuncheng/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/xuncheng/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/xuncheng/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

