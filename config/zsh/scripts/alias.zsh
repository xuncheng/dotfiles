alias ez="${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc"
alias et="${=EDITOR} ${XDG_CONFIG_HOME}/tmux/tmux.conf"
alias grep='grep --color'
alias x="exit"
alias del="rm -rf"
alias md="mkdir -p"
alias dots="cd $DOTFILES"
alias cl='clear'
alias src="exec $SHELL"

#-------------------------------------------------------------------------------
#  NEOVIM
#-------------------------------------------------------------------------------
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

#-------------------------------------------------------------------------------
#  APP ALIASES
#-------------------------------------------------------------------------------
(( $+commands[bat] )) && alias cat='bat'
(( $+commands[kitty] )) && alias icat="kitty +kitten icat"
# Switch Tencent CloudBase account; completion lives in scripts/tcb-env.zsh
(( $+commands[tcb-env] )) && alias tu='tcb-env use'

# Unix
alias ...='cd ../..'
alias killruby='killall -9 ruby'
alias l='ls -lFh'
alias ll='ls -l'
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
alias t='tail -f'
alias cleanup='find . -type d -empty -delete'

# Ruby/Rails
# alias be='bundle exec'
# alias fs='foreman start'
# alias rc='rails console'
# alias rs='bundle install && rails server -p 3000 -b 0.0.0.0'
# alias rg='rails generate'
# alias rgm='rails generate migration'
# alias rrg='rake routes | ack'
# alias ss='spring stop'
# alias sidekiq='bundle exec sidekiq -e development -C ./config/sidekiq.yml'

# alias railstips='subl ~/Dropbox/Documents/rails-tips.txt'

alias gv='gh repo view -w'
# Homebrew's python formula only provides `python3`; resolve via PATH so the
# alias follows whichever version is installed rather than a hardcoded path.
(( $+commands[python3] )) && alias python='python3'

# List / delete node_modules folders recursively.
# -I is required: node_modules is normally gitignored and fd honours that by
# default, which would silently match nothing.
alias rnm="fd -HI -t d --prune '^node_modules\$' -X du -chs"
alias dnm="fd -HI -t d --prune '^node_modules\$' -X rm -rf"
