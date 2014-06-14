# expand functions in the prompt
setopt prompt_subst

_git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [ -n $ref ]; then
    branch_name="${ref#refs/heads/}"
    branch_name_max_length=$(($COLUMNS/5))
    if [ ${#branch_name} -gt $branch_name_max_length ]; then
      echo "$branch_name[0,$(($branch_name_max_length-3))]..."
    else
      echo $branch_name
    fi
  fi
}

_git_status() {
  git_status=$(cat "/tmp/git-status-$$")
  if [ -n "$(echo $git_status | grep "nothing to commit, working directory clean")" ]; then
    echo "unchanged"
  else
    echo "changed"
  fi
}

_git_prompt_color() {
  if [ -n "$1" ]; then
    current_git_status=$(_git_status)
    if [ "changed" = $current_git_status ]; then
      echo "$(_cyan $1)$(_red "✘")"
    elif [ "unchanged" = $current_git_status ]; then
      echo "$(_cyan $1)"
    fi
  else
    echo "$(_green $1)"
  fi
}

_color() {
  if [ -n "$1" ]; then
    echo "%{$fg[$2]%}$1%{$reset_color%}"
  fi
}

_default_color() {
  if [ -n "$1" ]; then
    echo "%{$reset_color%}$1"
  fi
}

_user_name() {
  if [ $USER != "Samuel" ]; then
    echo "$USER "
  fi
}

_separate()            { if [ -n "$1" ]; then echo " $1"; fi }
_grey()                { echo "$(_default_color "$1")" }
_yellow()              { echo "$(_color "$1" yellow)" }
_green()               { echo "$(_color "$1" green)" }
_red()                 { echo "$(_color "$1" red)" }
_cyan()                { echo "$(_color "$1" cyan)" }

_basic()               { echo "$(_user_name)$(_colored_path)" }
_colored_path()        { echo "$(_grey "%c")" }
_colored_git_branch()  { if [ -n "$(_git_prompt_info)" ]; then echo "($(_git_prompt_color "$(_git_prompt_info)"))"; fi }

function precmd {
  $(git status 2> /dev/null >! "/tmp/git-status-$$")
}

PROMPT='$(_basic)$(_colored_git_branch) $(_yellow "$") '
