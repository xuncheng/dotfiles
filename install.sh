#!/bin/sh

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

append_to_zshrc() {
  local text="$1"
  local skip_new_line="${2:-0}"
  local zshrc="$HOME/.zshrc"

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    gem update "$@"
  else
    gem install "$@"
  fi
}

change_shell_to_zsh() {
  case "$SHELL" in
    */zsh) : ;;
    *)
      fancy_echo "Changing your shell to zsh ..."
        chsh -s "$(which zsh)"
      ;;
  esac
}

install_homebrew() {
  if ! command -v brew >/dev/null; then
    fancy_echo "Installing Homebrew ..."
      curl -fsS \
        'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

      append_to_zshrc '# recommended by brew doctor'

      # shellcheck disable=SC2016
      append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1

      export PATH="/usr/local/bin:$PATH"
  fi
}

update_homebrew_formulaes() {
  if brew list | grep -Fq brew-cask; then
    fancy_echo "Uninstalling old Homebrew-Cask ..."
    brew uninstall --force brew-cask
  fi

  fancy_echo "Updating Homebrew formulae ..."
  brew update
  brew bundle
}

install_ruby() {
  fancy_echo "Configuring Ruby ..."
  find_latest_ruby() {
    rbenv install -l | grep -v - | tail -1 | sed -e 's/^ *//'
  }

  ruby_version="$(find_latest_ruby)"
  # shellcheck disable=SC2016
  append_to_zshrc 'eval "$(rbenv init - --no-rehash)"' 1
  eval "$(rbenv init -)"

  if ! rbenv versions | grep -Fq "$ruby_version"; then
    RUBY_CONFIGURE_OPTS=--with-openssl-dir=/usr/local/opt/openssl rbenv install -s "$ruby_version"
  fi

  rbenv global "$ruby_version"
  rbenv shell "$ruby_version"
  gem update --system
  gem_install_or_update 'bundler'
}

install_node() {
  if ! command -v nvm >/dev/null; then
    fancy_echo "Installing NVM ..."
      curl -fsS \
        'https://raw.githubusercontent.com/creationix/nvm/master/install.sh' | bash

      # TODO: install node failed!
      # fancy_echo "Configuring Node ..."
      # # shellcheck disable=SC1090
      # [ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"
      # nvm install stable
      # nvm alias default stable
  fi
}

install_dotfiles() {
  fancy_echo "Updating dotfiles ..."
  rake install
}

install_vim_plugins() {
  if [ ! -d "$HOME/.vim/bundle/vundle" ]; then
    fancy_echo "Installing vim plugins ..."
    git clone git@github.com:gmarik/Vundle.vim.git ~/.vim/bundle/vundle
    vundle
  fi
}


trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if [ ! -d "$HOME/.bin/" ]; then
  mkdir "$HOME/.bin"
fi

if [ ! -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
fi

# shellcheck disable=SC2016
append_to_zshrc 'export PATH="$HOME/.bin:$PATH"'

change_shell_to_zsh
install_homebrew
update_homebrew_formulaes
install_ruby
install_node
install_dotfiles
install_vim_plugins

fancy_echo "All installed."
