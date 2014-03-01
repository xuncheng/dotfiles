# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="samuel"
DISABLE_AUTO_UPDATE="true"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
export EDITOR='mvim -w'
export TERM=xterm-256color

alias zshconfig="mvim ~/.zshrc"
alias cls=clear

# Highlight search results
alias ack="ack --color-match=red"
alias ag="ag --color-match=31"

# Handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
