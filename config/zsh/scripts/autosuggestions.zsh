# Fish-style suggestions from history, shown greyed out ahead of the cursor.
# Accepted by the existing ^F (forward-char) and ^E (end-of-line) bindings from
# key-bindings.zsh, which are autosuggestions' default accept widgets.
#
# NOTE: load order relative to zsh-syntax-highlighting does not matter here.
# Autosuggestions re-binds its widgets on every precmd precisely so that it ends
# up wrapping the highlighter's wrappers rather than the other way around.
# Setting ZSH_AUTOSUGGEST_MANUAL_REBIND would skip that rebind for speed, but
# then this file would have to be sourced *after* the highlighter, i.e. moved
# out of scripts/ and into .zshrc.
_autosuggestions="${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -r "$_autosuggestions" ]] && source "$_autosuggestions"
unset _autosuggestions
