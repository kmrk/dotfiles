#!/usr/bin/env bash
set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEYCAST_SCRIPT="$CURRENT_DIR/scripts/keycast.sh"

toggle_key="$(tmux show-option -gqv @keycast_toggle_key)"
toggle_key="${toggle_key:-K}"

status_length="$(tmux show-option -gqv @keycast_status_right_length)"
status_length="${status_length:-160}"

status_segment="#($KEYCAST_SCRIPT status)"
current_status_right="$(tmux show-option -gqv status-right)"
current_status_right_length="$(tmux show-option -gqv status-right-length)"

tmux bind-key "$toggle_key" run-shell -b "$KEYCAST_SCRIPT toggle"

case "$current_status_right" in
    *"$status_segment"*) ;;
    *) tmux set-option -gq status-right "$status_segment$current_status_right" ;;
esac

if [[ "${current_status_right_length:-0}" =~ ^[0-9]+$ ]] && (( current_status_right_length < status_length )); then
    tmux set-option -gq status-right-length "$status_length"
fi
