export NVM_PATH="${HOME}/.nvm"
source "$(brew --prefix nvm)/nvm.sh" # Load NVM

# Calling `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  fi
}
add-zsh-hook chpwd load-nvmrc
