source $HOME/.aliasrc

for zsh_source in $HOME/.zsh_profile.d/*.zsh; do
  source $zsh_source
done

export PATH="$HOME/.bin:/usr/local/bin:$PATH"
