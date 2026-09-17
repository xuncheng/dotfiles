#!/usr/bin/env bash
# Claude Code 状态栏：目录 | 分支 | 模型 | 上下文 | 5 小时用量条 + 重置时间

# 宽度按字符计算，locale 不是 UTF-8 时 bash 会按字节数、sed 也会报错
export LC_ALL=en_US.UTF-8

IFS=$'\t' read -r dir model ctx usage reset < <(
  jq -r '[
    .workspace.current_dir,
    .model.display_name,
    (.context_window.used_percentage // 0 | floor),
    (.rate_limits.five_hour.used_percentage // "" | if . == "" then . else floor end),
    (.rate_limits.five_hour.resets_at // "")
  ] | @tsv'
)

reset_c=$'\033[0m'
dim=$'\033[2m'
blue=$'\033[34m'
yellow=$'\033[33m'
orange=$'\033[38;5;214m'
cyan=$'\033[36m'
green=$'\033[32m'
red=$'\033[31m'
sep=" ${dim}|${reset_c} "

line="${blue}${dir##*/}${reset_c}"

branch=$(git -C "$dir" branch --show-current 2>/dev/null)
[[ -n $branch ]] && line+="${sep}${yellow}⎇ ${branch}${reset_c}"

line+="${sep}${orange}${model}${reset_c}"
line+="${sep}${cyan}Ctx: ${ctx}%${reset_c}"

# rate_limits 只对 Pro/Max 订阅、且会话收到第一次 API 响应后才出现
if [[ -n $usage ]]; then
  if (( usage >= 90 )); then color=$red
  elif (( usage >= 70 )); then color=$yellow
  else color=$green
  fi

  width=10
  filled=$(( usage * width / 100 ))
  bar=$(printf '%*s' "$filled" '' | tr ' ' '█')$(printf '%*s' "$(( width - filled ))" '' | tr ' ' '░')

  line+="${sep}${color}Usage: ${usage}% ${bar}${reset_c}"
  [[ -n $reset ]] && line+=" ${dim}→ Reset: $(date -r "$reset" +%H:%M)${reset_c}"
fi

# 靠右对齐：Claude Code 不提供对齐选项，只能按 COLUMNS 手动补左侧空格
# 右侧留白抵消界面自带的边距，否则会被截断或折行
right_margin=4
plain=$(printf '%s' "$line" | sed $'s/\033\\[[0-9;]*m//g')
pad=$(( ${COLUMNS:-0} - ${#plain} - right_margin ))
# Claude Code 会裁掉行首空白，先输出一个零宽的 reset 让空格不在行首
(( pad > 0 )) && printf '%s%*s' "$reset_c" "$pad" ''
printf '%s\n' "$line"
