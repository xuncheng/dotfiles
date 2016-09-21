Xuncheng's dotfiles
===================

Requirements
------------

Set zsh as your login shell:

    chsh -s $(which zsh)

Enable Mac OS X programs *pbpaste* and *pbcopy* access under *tmux*:

    # https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/blob/master/README.md
    brew install reattach-to-user-namespace

Install
------------

Clone and install the dofiles:

    git clone git@github.com:xuncheng/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    rake install

    # Set up [Vundle](http://github.com/gmarik/Vundle.vim):
    git clone git@github.com:gmarik/Vundle.vim.git ~/.vim/bundle/vundle
