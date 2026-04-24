#!/usr/bin/env bash
set -euo pipefail

target_session="${1:-}"
if [ -z "$target_session" ]; then
  exit 1
fi

tmux display-popup \
  -x C -y C -w 60 -h 7 \
  -s "fg=#ff0033,bg=#fff8e7,bold" \
  -S "fg=#8b5a2b,bg=#fff8e7" \
  -e "TARGET_SESSION=$target_session" \
  -E \
  "bash -lc 'msg=\"Kill session \$TARGET_SESSION? [yes/no]\"; cols=\$(tput cols 2>/dev/null || echo 80); pad=\$(( (cols-\${#msg})/2 )); [ \$pad -lt 0 ] && pad=0; printf \"\\n%*s%s\\n\\n\" \"\$pad\" \"\" \"\$msg\"; read -r ans; if [ \"\$ans\" = yes ] || [ \"\$ans\" = YES ]; then tmux kill-session -t \"\$TARGET_SESSION\"; fi'"
