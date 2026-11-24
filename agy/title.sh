#!/usr/bin/env bash
# Antigravity CLI terminal title: session title, falling back to directory name.

export LC_ALL=en_US.UTF-8

title=$(jq -r '
  (.conversation_title // "") as $t |
  if ($t | length) > 0 then
    $t
  else
    ((.workspace.current_dir // .cwd // "agy") | sub("/+$"; "") | split("/") | last)
  end
' 2>/dev/null || true)

printf '%s\n' "${title:-agy}"
