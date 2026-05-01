#!/usr/bin/env bash

keycast_script="$HOME/.config/tmux/plugins/tmux-keycast/scripts/keycast.sh"
state_dir="${TMPDIR:-/tmp}/tmux-im-status-${UID}"
state_file="$state_dir/state"
pid_file="$state_dir/monitor.pid"
poll_interval="${IM_STATUS_POLL_INTERVAL:-0.25}"
im_bin="${IM_SELECT_BIN:-im-select.exe}"

mkdir -p "$state_dir"

read_im_state() {
    command -v "$im_bin" >/dev/null 2>&1 || return 1
    "$im_bin" 2>/dev/null | tr -d '\r\n'
}

apply_state() {
    local next_state="$1"
    local last_state

    last_state="$(cat "$state_file" 2>/dev/null || true)"
    [ "$next_state" != "$last_state" ] || return 0

    case "$next_state" in
        en)
            tmux set-option -gq @im_status_label 'EN' 2>/dev/null || true
            tmux set-option -gq @im_status_bg '#5fa36a' 2>/dev/null || true
            tmux set-option -gq @im_status_fg '#0f1720' 2>/dev/null || true
            printf 'en' >"$state_file"
            [ -x "$keycast_script" ] && "$keycast_script" resume >/dev/null 2>&1 || true
            ;;
        zh)
            tmux set-option -gq @im_status_label '中' 2>/dev/null || true
            tmux set-option -gq @im_status_bg '#e06c75' 2>/dev/null || true
            tmux set-option -gq @im_status_fg '#ffffff' 2>/dev/null || true
            printf 'zh' >"$state_file"
            [ -x "$keycast_script" ] && "$keycast_script" pause >/dev/null 2>&1 || true
            ;;
    esac

    tmux refresh-client -S 2>/dev/null || true
}

monitor() {
    local old_pid im_state next_state

    old_pid="$(cat "$pid_file" 2>/dev/null || true)"
    if [ -n "$old_pid" ] && kill -0 "$old_pid" 2>/dev/null; then
        exit 0
    fi
    printf '%s\n' "$$" >"$pid_file"
    trap 'rm -f "$pid_file"' EXIT INT TERM

    while tmux display-message -p '#{pid}' >/dev/null 2>&1; do
        im_state="$(read_im_state || true)"
        next_state=''
        case "$im_state" in
            1033|0409|00000409) next_state='en' ;;
            2052|0804|00000804) next_state='zh' ;;
        esac

        [ -n "$next_state" ] && apply_state "$next_state"
        sleep "$poll_interval"
    done
}

case "${1:-status}" in
    monitor)
        monitor
        ;;
    status)
        case "$(cat "$state_file" 2>/dev/null || true)" in
            zh) printf '中' ;;
            *) printf 'EN' ;;
        esac
        ;;
    *)
        printf 'Usage: %s {monitor|status}\n' "$0" >&2
        exit 2
        ;;
esac
