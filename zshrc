source $HOME/.aliasrc

for zsh_source in $HOME/.zsh_profile.d/*.zsh; do
  source $zsh_source
done

source $HOME/.zsh_profile.d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
