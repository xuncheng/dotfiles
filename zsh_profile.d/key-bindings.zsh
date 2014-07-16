# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
bindkey '^A' beginning-of-line  # 跳至命令行开头
bindkey '^E' end-of-line        # 跳至命令行行尾
bindkey '^P' up-history         # 上一条命令
bindkey '^N' down-history       # 下一条命令
bindkey '^F' forward-char       # 向前移动一个字符(chracter)
bindkey '^B' backward-char      # 向后移动一个字符
bindkey '^U' backward-kill-line # 删除当前光标位置到命令行行首的全部字符（不包括光标所在字符）
bindkey '^K' kill-line          # 删除当前光标位置到命令行行尾的全部字符（包括光标所在字符）
