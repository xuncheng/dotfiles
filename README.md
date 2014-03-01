# Config Files

### Installation

```terminal
git clone git://github.com/xuncheng/dotfiles ~/.dotfiles
cd ~/.dotfiles
source install.sh
```

---

### Install Homebrew formulae

```terminal
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew bundle ~/.dotfiles/Brewfile
```

---

### Install native apps with `brew cask`
You could install native apps with [`brew cask`](https://github.com/phinze/homebrew-cask)

```terminal
~/.dotfiles/cask
```

---

### Others

```terminal
unlink ~/.vimrc # anything
rm ~/.zshrc # careful here
rm ~/.gitconfig
rm -rf ~/.dotfiles
rm -rf ~/.oh-my-zsh
chsh -s /bin/bash # change back to Bash if you want
```
