#!/usr/bin/env bash
set -euo pipefail

state_dir="${TMPDIR:-/tmp}/tmux-keycast-${UID}"
keys_file="$state_dir/keys"
bindings_file="$state_dir/root-bindings.tmux"
installed_keys_file="$state_dir/installed-keys"
wrapped_bindings_file="$state_dir/wrapped-bindings.tmux"
original_table_file="$state_dir/original-table.tmux"
history_file="$state_dir/history"
enabled_option="@keycast_enabled"
paused_option="@keycast_paused"
max_items_option="@keycast_max_items"
block_width_option="@keycast_block_width"
original_table="keycast-original"
atom_bg="#282c34"
atom_fg="#abb2bf"
atom_key_bg="#61afef"
atom_key_fg="#282c34"
atom_count_fg="#5b6473"

mkdir -p "$state_dir"

script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")"

quote_shell() {
    printf '%q' "$1"
}

max_items() {
    local configured
    configured="$(tmux show-option -gqv "$max_items_option" 2>/dev/null || true)"
    if [[ "$configured" =~ ^[0-9]+$ ]] && (( configured > 0 )); then
        printf '%s' "$configured"
    else
        printf 1
    fi
}

block_width() {
    local configured
    configured="$(tmux show-option -gqv "$block_width_option" 2>/dev/null || true)"
    if [[ "$configured" =~ ^[0-9]+$ ]] && (( configured > 0 )); then
        printf '%s' "$configured"
    else
        printf 7
    fi
}

format_block() {
    local width display
    width="$(block_width)"
    display="$1"
    printf "%-${width}.${width}s" "$display"
}

render_history_item() {
    local label="$1"
    local count="$2"
    local width prefix suffix display padding

    width="$(block_width)"
    prefix="$label"
    suffix=''

    if [[ "$count" =~ ^[0-9]+$ ]] && (( count > 1 )); then
        suffix=" x$count"
    fi

    display="$prefix$suffix"
    if (( ${#display} < width )); then
        padding="$(printf '%*s' "$((width - ${#display}))" '')"
    else
        padding=''
    fi

    if [[ -n "$suffix" ]]; then
        printf ' #[bold,fg=%s,bg=%s] %s#[fg=%s]%s%s#[default]' \
            "$atom_key_fg" "$atom_key_bg" "$prefix" "$atom_count_fg" "$suffix" "$padding"
    else
        printf ' #[bold,fg=%s,bg=%s] %s%s#[default]' \
            "$atom_key_fg" "$atom_key_bg" "$prefix" "$padding"
    fi
}

key_rows() {
    local c

    for c in {a..z}; do
        printf 'C-%s\tC-%s\tC-%s\n' "$c" "$c" "$c"
    done

    printf '%s\t%s\t%s\n' Space Space SPC
    printf '%s\t%s\t%s\n' Enter Enter RET
    printf '%s\t%s\t%s\n' Tab Tab TAB
    printf '%s\t%s\t%s\n' BSpace BSpace BS
    printf '%s\t%s\t%s\n' Escape Escape ESC
    printf '%s\t%s\t%s\n' Up Up UP
    printf '%s\t%s\t%s\n' Down Down DN
    printf '%s\t%s\t%s\n' Left Left LT
    printf '%s\t%s\t%s\n' Right Right RT
    printf '%s\t%s\t%s\n' Home Home HM
    printf '%s\t%s\t%s\n' End End END
    printf '%s\t%s\t%s\n' IC IC INS
    printf '%s\t%s\t%s\n' DC DC DEL
    printf '%s\t%s\t%s\n' PPage PPage PUP
    printf '%s\t%s\t%s\n' NPage NPage PDN

    for c in {1..12}; do
        printf 'F%s\tF%s\tF%s\n' "$c" "$c" "$c"
    done

    printf '%s\t%s\t%s\n' '!' '!' '!'
    printf '%s\t%s\t%s\n' '"' '"' '"'
    printf '%s\t%s\t%s\n' '#' '#' '#'
    printf '%s\t%s\t%s\n' '$' '$' '$'
    printf '%s\t%s\t%s\n' '%' '%' '%'
    printf '%s\t%s\t%s\n' '&' '&' '&'
    printf '%s\t%s\t%s\n' "'" "'" "'"
    printf '%s\t%s\t%s\n' '(' '(' '('
    printf '%s\t%s\t%s\n' ')' ')' ')'
    printf '%s\t%s\t%s\n' '*' '*' '*'
    printf '%s\t%s\t%s\n' '+' '+' '+'
    printf '%s\t%s\t%s\n' ',' ',' ','
    printf '%s\t%s\t%s\n' '-' '-' '-'
    printf '%s\t%s\t%s\n' '.' '.' '.'
    printf '%s\t%s\t%s\n' '/' '/' '/'
    for c in {0..9}; do
        printf '%s\t%s\t%s\n' "$c" "$c" "$c"
    done
    printf '%s\t%s\t%s\n' ':' ':' ':'
    printf '%s\t%s\t%s\n' '\;' ';' ';'
    printf '%s\t%s\t%s\n' '<' '<' '<'
    printf '%s\t%s\t%s\n' '=' '=' '='
    printf '%s\t%s\t%s\n' '>' '>' '>'
    printf '%s\t%s\t%s\n' '?' '?' '?'
    printf '%s\t%s\t%s\n' '@' '@' '@'
    for c in {A..Z}; do
        printf '%s\t%s\t%s\n' "$c" "$c" "$c"
    done
    printf '%s\t%s\t%s\n' '[' '[' '['
    printf '%s\t%s\t%s\n' '\' '\' '\'
    printf '%s\t%s\t%s\n' ']' ']' ']'
    printf '%s\t%s\t%s\n' '^' '^' '^'
    printf '%s\t%s\t%s\n' '_' '_' '_'
    printf '%s\t%s\t%s\n' '`' '`' '`'
    for c in {a..z}; do
        printf '%s\t%s\t%s\n' "$c" "$c" "$c"
    done
    printf '%s\t%s\t%s\n' '{' '{' '{'
    printf '%s\t%s\t%s\n' '|' '|' '|'
    printf '%s\t%s\t%s\n' '}' '}' '}'
    printf '%s\t%s\t%s\n' '~' '~' '~'
}

save_keys_file() {
    key_rows >"$keys_file"
}

root_bound_keys() {
    tmux list-keys -T root |
        awk '{
            for (i = 1; i <= NF; i++) {
                if ($i == "-T" && $(i + 1) == "root") {
                    print $(i + 2)
                    next
                }
            }
        }'
}

root_binding_for_key() {
    tmux list-keys -T root "$1" 2>/dev/null || true
}

unbind_keycast_bindings() {
    local line token previous table key

    while IFS= read -r line; do
        case "$line" in
            *"$script_path"*) ;;
            *) continue ;;
        esac

        previous=''
        table=''
        key=''
        for token in $line; do
            if [[ "$previous" == "-T" ]]; then
                table="$token"
                previous=''
                continue
            fi
            if [[ -n "$table" && -z "$key" ]]; then
                key="$token"
                break
            fi
            previous="$token"
        done

        if [[ "$table" == root && -n "$key" ]]; then
            tmux unbind-key -nq "$key" 2>/dev/null || true
        fi
    done < <(tmux list-keys -T root)
}

add_key() {
    local label="$1"
    local limit tmp last_label last_count
    limit="$(max_items)"
    tmp="$history_file.$$"

    if [[ -s "$history_file" ]]; then
        IFS=$'\t' read -r last_label last_count <"$history_file" || true
        last_count="${last_count:-1}"
    fi

    if [[ "${last_label:-}" == "$label" && "$last_count" =~ ^[0-9]+$ ]]; then
        {
            printf '%s\t%s\n' "$label" "$((last_count + 1))"
            tail -n +2 "$history_file" | head -n "$((limit - 1))"
        } >"$tmp"
    else
        {
            printf '%s\t1\n' "$label"
            if [[ -f "$history_file" ]]; then
                head -n "$((limit - 1))" "$history_file"
            fi
        } >"$tmp"
    fi

    mv "$tmp" "$history_file"
    tmux refresh-client -S 2>/dev/null || true
}

press_key() {
    local label="$1"
    local send_key="$2"
    local pane="$3"

    add_key "$label"
    tmux send-keys -t "$pane" "$send_key"
}

status() {
    local enabled label count rendered=''

    enabled="$(tmux show-option -gqv "$enabled_option" 2>/dev/null || true)"
    [[ "$enabled" == 1 ]] || exit 0

    if [[ -f "$history_file" ]]; then
        while IFS=$'\t' read -r label count; do
            count="${count:-1}"
            case "$label" in
                '#') label='##' ;;
            esac
            rendered="$(render_history_item "$label" "$count")$rendered"
        done <"$history_file"
    fi

    printf '%s' "$rendered"
}

install_keycast_bindings() {
    local key send_key label cmd binding original_binding

    while IFS=$'\t' read -r key send_key label; do
        binding="$(root_binding_for_key "$key")"
        if [[ -n "$binding" && "$binding" != *"$script_path"* ]]; then
            original_binding="${binding/-T root/-T $original_table}"
            printf '%s\n' "$binding" >>"$wrapped_bindings_file"
            printf '%s\n' "$original_binding" >>"$original_table_file"

            cmd="$(quote_shell "$script_path") add $(quote_shell "$label")"
            tmux bind-key -n "$key" run-shell "$cmd" "\\;" switch-client -T "$original_table" "\\;" send-keys -K "$key"
        else
            cmd="$(quote_shell "$script_path") press $(quote_shell "$label") $(quote_shell "$send_key") '#{pane_id}'"
            tmux bind-key -n "$key" run-shell "$cmd"
        fi
        printf '%s\n' "$key" >>"$installed_keys_file"
    done <"$keys_file"

    if [[ -s "$original_table_file" ]]; then
        tmux source-file "$original_table_file"
    fi
}

enable() {
    if [[ "$(tmux show-option -gqv "$enabled_option" 2>/dev/null || true)" == 1 ]]; then
        disable >/dev/null 2>&1 || true
    fi

    save_keys_file
    : >"$history_file"
    : >"$installed_keys_file"
    : >"$wrapped_bindings_file"
    : >"$original_table_file"
    tmux unbind-key -a -T "$original_table" 2>/dev/null || true
    tmux set-option -gq "$enabled_option" 1
    tmux set-option -gq "$paused_option" 0

    install_keycast_bindings

    tmux display-message 'keycast: on'
    tmux refresh-client -S
}

disable() {
    local key

    unbind_keycast_bindings

    if [[ -s "$installed_keys_file" ]]; then
        while IFS= read -r key; do
            tmux unbind-key -nq "$key" 2>/dev/null || true
        done <"$installed_keys_file"
        : >"$installed_keys_file"
    fi

    if [[ -s "$wrapped_bindings_file" ]]; then
        tmux source-file "$wrapped_bindings_file"
        : >"$wrapped_bindings_file"
    fi

    tmux unbind-key -a -T "$original_table" 2>/dev/null || true

    # Migration path for the earlier version that temporarily replaced all
    # root bindings. Once restored, future toggles only remove installed keys.
    if [[ -s "$bindings_file" ]]; then
        tmux source-file "$bindings_file"
        rm -f "$bindings_file"
    fi

    unbind_keycast_bindings

    tmux set-option -gq "$enabled_option" 0
    tmux set-option -gq "$paused_option" 0
    : >"$history_file"
    tmux display-message 'keycast: off'
    tmux refresh-client -S
}

pause() {
    if [[ "$(tmux show-option -gqv "$enabled_option" 2>/dev/null || true)" != 1 ]]; then
        exit 0
    fi
    if [[ "$(tmux show-option -gqv "$paused_option" 2>/dev/null || true)" == 1 ]]; then
        exit 0
    fi

    unbind_keycast_bindings

    if [[ -s "$installed_keys_file" ]]; then
        while IFS= read -r key; do
            tmux unbind-key -nq "$key" 2>/dev/null || true
        done <"$installed_keys_file"
    fi

    if [[ -s "$wrapped_bindings_file" ]]; then
        tmux source-file "$wrapped_bindings_file"
    fi

    tmux unbind-key -a -T "$original_table" 2>/dev/null || true
    tmux set-option -gq "$paused_option" 1
    tmux refresh-client -S 2>/dev/null || true
}

resume() {
    if [[ "$(tmux show-option -gqv "$enabled_option" 2>/dev/null || true)" != 1 ]]; then
        exit 0
    fi
    if [[ "$(tmux show-option -gqv "$paused_option" 2>/dev/null || true)" != 1 ]]; then
        exit 0
    fi

    tmux set-option -gq "$paused_option" 0
    : >"$installed_keys_file"
    if [[ ! -s "$keys_file" ]]; then
        save_keys_file
    fi
    install_keycast_bindings
}

case "${1:-}" in
    add)
        add_key "${2:-}"
        ;;
    press)
        press_key "${2:-}" "${3:-}" "${4:-}"
        ;;
    status)
        status
        ;;
    enable)
        enable
        ;;
    disable)
        disable
        ;;
    pause)
        pause
        ;;
    resume)
        resume
        ;;
    toggle)
        if [[ "$(tmux show-option -gqv "$enabled_option" 2>/dev/null || true)" == 1 ]]; then
            disable
        else
            enable
        fi
        ;;
    *)
        printf 'Usage: %s {toggle|enable|disable|pause|resume|status|add <label>|press <label> <key> <pane>}\n' "$0" >&2
        exit 2
        ;;
esac
