#!/usr/bin/env bash
set -euo pipefail

target_pane="${1:-}"
if [ -z "$target_pane" ]; then
  exit 1
fi

prev_style="$(tmux show-options -wqv pane-active-border-style || true)"
if [ -z "$prev_style" ]; then
  prev_style="fg=#89b4fa"
fi

restore_border() {
  tmux set -w pane-active-border-style "$prev_style" >/dev/null 2>&1 || true
}
trap restore_border EXIT

tmux set -w pane-active-border-style "fg=#ff0033"

tmux display-popup \
  -x C -y C -w 60 -h 7 \
  -s "fg=#ff0033,bg=#fff8e7,bold" \
  -S "fg=#8b5a2b,bg=#fff8e7" \
  -e "TARGET_PANE=$target_pane" \
  -E \
  "bash -lc 'msg=\"Kill current pane? [y/n]\"; cols=\$(tput cols 2>/dev/null || echo 80); pad=\$(( (cols-\${#msg})/2 )); [ \$pad -lt 0 ] && pad=0; printf \"\\n%*s%s\\n\\n\" \"\$pad\" \"\" \"\$msg\"; read -r -n1 k; if [ \"\$k\" = y ] || [ \"\$k\" = Y ]; then tmux kill-pane -t \"\$TARGET_PANE\"; fi'"
