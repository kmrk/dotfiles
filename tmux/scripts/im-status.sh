#!/usr/bin/env bash

im_bin="${IM_SELECT_BIN:-im-select.exe}"

if ! command -v "$im_bin" >/dev/null 2>&1; then
    exit 0
fi

im_state="$("$im_bin" 2>/dev/null | tr -d '\r\n')"

case "$im_state" in
    1033|0409|00000409)
        printf '#[fg=#000000,bg=#50fa7b] EN #[default]'
        ;;
    2052|0804|00000804)
        printf '#[fg=#ffffff,bg=#ff0000] 中 #[default]'
        ;;
esac
