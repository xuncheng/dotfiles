# Plugin for highlighting file content
# Plugin highlights file content based on the filename extension.
# If no highlighting method supported for given extension then it tries 
# guess it by looking for file content.
#
# sudo easy_install Pygments

alias colorize='colorize_via_pygmentize'

colorize_via_pygmentize() {
  if [ ! -x "$(which pygmentize)" ]; then
    echo "package \'pygmentize\' is not installed!"
    return -1
  fi
  if [ $# -eq 0 ]; then
    pygmentize -g $@
  fi
  for FNAME in $@
  do
    filename=$(basename "$FNAME")
    filename=$(basename "$FNAME")
    lexer=`pygmentize -N \"$filename\"`
    if [ "Z$lexer" != "Ztext" ]; then
      pygmentize -l $lexer "$FNAME"
    else
      pygmentize -g "$FNAME"
    fi
  done
}
