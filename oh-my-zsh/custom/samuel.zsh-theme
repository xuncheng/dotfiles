local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local user_host='%{$terminfo[bold]$fg[green]%}%n%{$reset_color%}'
# local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'
local current_dir='%c'
local git_branch='$(git_prompt_info)%{$reset_color%}'

PROMPT="${user_host}:${current_dir}${git_branch}$ "
RPS1='${return_code}'

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}%B✘%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔%{$reset_color%}"
