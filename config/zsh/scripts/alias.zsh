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
(( $+commands[kitty] )) && alias kitty-icon="$DOTFILES/macos/kitty-icon.zsh"

# Unix
alias ...='cd ../..'
alias ack='ag --color-match=31'
alias ag='ag --color-match=31'
alias c='colorize'
alias killruby='killall -9 ruby'
alias ls='ls -G'
alias l='ls -lFh'
alias ll='ls -l'
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'
alias retag='ctags -R --exclude=.svn --exclude=.git --exclude=log --exclude=tmp *'
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
alias python=/opt/homebrew/bin/python3

