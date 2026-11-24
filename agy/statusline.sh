#!/usr/bin/env bash
# Antigravity CLI status line: mode, model, context, and active-model quota on one line.

export LC_ALL=en_US.UTF-8

payload=$(cat)
[[ -z $payload ]] && exit 0

# Use "-" placeholders so bash IFS=$'\t' does not collapse empty fields.
IFS=$'\t' read -r ctx term_width mode model_name effort < <(
  printf '%s' "$payload" | jq -r '
    ((.model.effort // "") | ascii_downcase) as $effort |
    ((.model.display_name // "") |
      if ($effort | length) > 0 then sub(" \\([^()]+\\)$"; "") else . end
    ) as $model |
    [
      (.context_window.used_percentage // 0 | floor),
      (.terminal_width // 0),
      (if (.cycle_mode // "") != "" then .cycle_mode else "-" end),
      (if ($model | length) > 0 then $model else "-" end),
      (if ($effort | length) > 0 then $effort else "-" end)
    ] | @tsv
  ' 2>/dev/null || printf '0\t0\t-\t-\t-\n'
)

reset_c=$'\033[0m'
dim=$'\033[2m'
cyan=$'\033[36m'
green=$'\033[32m'
yellow=$'\033[33m'
red=$'\033[31m'
sep=" ${dim}·${reset_c} "

if (( ctx >= 90 )); then ctx_color=$red
elif (( ctx >= 70 )); then ctx_color=$yellow
else ctx_color=$cyan
fi

line="${ctx_color}Ctx ${ctx}%${reset_c}"

# Filter quota buckets to the active model family (gemini-* vs 3p-*),
# falling back to all active buckets if the model prefix doesn't match.
quota_rows=$(printf '%s' "$payload" | jq -r '
  ((.model.id // .model.display_name // "") | ascii_downcase) as $model |
  (if ($model | contains("gemini")) then "gemini-"
   elif ($model | length) > 0 then "3p-"
   else "" end) as $prefix |
  ((.quota // {}) | to_entries | map(select((.value.disabled // false) | not))) as $active |
  (if ($prefix | length) > 0 then
     ($active | map(select(.key | startswith($prefix))))
   else [] end) as $matched |
  (if ($matched | length) > 0 then $matched else $active end) |
  .[] | [
    .key,
    (if .value.remaining_fraction != null then (((1 - .value.remaining_fraction) * 100) | round) else "-" end),
    (.value.remaining_amount // "-"),
    (.value.reset_in_seconds // "-")
  ] | @tsv
' 2>/dev/null || true)

now=$(date +%s)
while IFS=$'\t' read -r bucket used remaining reset_sec; do
  [[ -z $bucket ]] && continue
  case "$bucket" in
    *-5h) label="5h" ;;
    *-weekly) label="7d" ;;
    *) label="$bucket" ;;
  esac

  if [[ $used != "-" && -n $used ]]; then
    (( used < 0 )) && used=0
    (( used > 100 )) && used=100
    if (( used >= 90 )); then color=$red
    elif (( used >= 70 )); then color=$yellow
    else color=$green
    fi
    line+="${sep}${color}${label} ${used}%${reset_c}"
  elif [[ $remaining != "-" && -n $remaining ]]; then
    line+="${sep}${green}${label} ${remaining}${reset_c}"
  else
    continue
  fi

  if [[ $reset_sec != "-" && -n $reset_sec ]] && (( reset_sec > 0 )); then
    reset_ts=$(( now + reset_sec ))
    if (( reset_sec >= 86400 )); then
      reset_fmt=$(date -r "$reset_ts" '+%m-%d' 2>/dev/null || true)
    else
      reset_fmt=$(date -r "$reset_ts" '+%H:%M' 2>/dev/null || true)
    fi
    [[ -n $reset_fmt ]] && line+=" ${dim}(${reset_fmt})${reset_c}"
  fi
done <<< "$quota_rows"

meta=""
if [[ $mode != "-" && -n $mode ]]; then
  meta="${yellow}${mode}${reset_c}"
fi
if [[ $model_name != "-" && -n $model_name ]]; then
  [[ -n $meta ]] && meta+="$sep"
  meta+="${dim}${model_name}${reset_c}"
fi
if [[ $effort != "-" && -n $effort ]]; then
  [[ -n $meta ]] && meta+="$sep"
  meta+="${dim}${effort}${reset_c}"
fi
[[ -n $meta ]] && line+="${sep}${meta}"

# Right-align using terminal_width from the payload; emit a zero-width reset
# before padding so leading spaces are not trimmed.
width=${term_width:-${COLUMNS:-0}}
right_margin=1
plain=$(printf '%s' "$line" | sed $'s/\033\\[[0-9;]*m//g')
pad=$(( width - ${#plain} - right_margin ))
(( pad > 0 )) && printf '%s%*s' "$reset_c" "$pad" ''
printf '%s\n' "$line"
