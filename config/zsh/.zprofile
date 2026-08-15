#-------------------------------------------------------------------------------
# Homebrew
#-------------------------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

#-------------------------------------------------------------------------------
#               $PATH Updates
#-------------------------------------------------------------------------------
# NOTE: this is here because it must be loaded after homebrew is added to the
# path which is done in the .zprofile which loads after the .zshenv

# MacOS ships with an older version of Ruby which is built against an X86
# system rather than ARM i.e. for M1+. So replace the system ruby with an
# updated one from Homebrew and ensure it is before /usr/bin/ruby
# Prepend to PATH
export BREW_PREFIX="$(brew --prefix)"
path=(
  # Glob qualifiers match .zshenv: (N-/) skips the entry when ruby is not
  # installed instead of leaving a dead directory on PATH, and (Nn[-1]-/) picks
  # the highest installed gems version rather than pinning one.
  "$BREW_PREFIX"/opt/ruby/bin(N-/)
  "$BREW_PREFIX"/lib/ruby/gems/*/bin(Nn[-1]-/)
  $path
)
