#!/usr/bin/env bash

im_bin="${IM_SELECT_BIN:-im-select.exe}"

if ! command -v "$im_bin" >/dev/null 2>&1; then
    exit 0
fi

im_state="$("$im_bin" 2>/dev/null | tr -d '\r\n')"
keycast_script="$HOME/.config/tmux/plugins/tmux-keycast/scripts/keycast.sh"
state_dir="${TMPDIR:-/tmp}/tmux-im-status-${UID}"
state_file="$state_dir/state"
mkdir -p "$state_dir"
last_state="$(cat "$state_file" 2>/dev/null || true)"

case "$im_state" in
    1033|0409|00000409)
        if [ "$last_state" != "en" ]; then
            if [ -x "$keycast_script" ]; then
                "$keycast_script" resume >/dev/null 2>&1 || true
            fi
            tmux set-option -gq @im_status_bg '#5fa36a' 2>/dev/null || true
            tmux set-option -gq @im_status_fg '#0f1720' 2>/dev/null || true
            printf 'en' >"$state_file"
        fi
        printf 'EN'
        ;;
    2052|0804|00000804)
        if [ "$last_state" != "zh" ]; then
            if [ -x "$keycast_script" ]; then
                "$keycast_script" pause >/dev/null 2>&1 || true
            fi
            tmux set-option -gq @im_status_bg '#e06c75' 2>/dev/null || true
            tmux set-option -gq @im_status_fg '#ffffff' 2>/dev/null || true
            printf 'zh' >"$state_file"
        fi
        printf '中'
        ;;
esac
