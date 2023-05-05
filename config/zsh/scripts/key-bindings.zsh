# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
bindkey '^A' beginning-of-line  # jump to the start of the line
bindkey '^E' end-of-line        # jump to the end of the line
bindkey '^P' up-history         # previous command
bindkey '^N' down-history       # next command
bindkey '^F' forward-char       # move forward one character
bindkey '^B' backward-char      # move back one character
bindkey '^U' backward-kill-line # delete to the start of the line, excluding the cursor
bindkey '^K' kill-line          # delete to the end of the line, including the cursor
