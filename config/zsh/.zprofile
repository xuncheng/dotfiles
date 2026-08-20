#-------------------------------------------------------------------------------
# Homebrew
#-------------------------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# Cached once here so .zshrc and friends don't each shell out to `brew --prefix`.
export BREW_PREFIX="$(brew --prefix)"
