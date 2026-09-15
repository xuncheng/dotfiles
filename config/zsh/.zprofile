#-------------------------------------------------------------------------------
# Homebrew
#-------------------------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# Volta must precede Homebrew, or a node pulled in as a brew dependency shadows the Volta shim.
path=(${VOLTA_HOME}/bin(N-/) ${path:#${VOLTA_HOME}/bin})

# Cached once here so .zshrc and friends don't each shell out to `brew --prefix`.
export BREW_PREFIX="$(brew --prefix)"
