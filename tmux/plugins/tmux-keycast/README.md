# tmux-keycast

A small tmux keycast plugin that shows recent keys in `status-right`.

## Usage

Load the local plugin before TPM is initialized:

```tmux
run '~/.config/tmux/plugins/tmux-keycast/keycast.tmux'
```

Reload tmux config, then press `prefix + K` to toggle keycast.

## Options

```tmux
set -g @keycast_toggle_key 'K'
set -g @keycast_max_items 1
set -g @keycast_block_width 7
set -g @keycast_status_right_length 160
```

When a key already has a root-table binding, the plugin wraps that binding so it
records the key label and then runs the original command from an internal tmux
table. Unbound keys are recorded and forwarded to the active pane.
