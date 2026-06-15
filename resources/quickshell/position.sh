#!/usr/bin/env bash
set -euo pipefail

if ! pgrep -x .quickshell-wra >/dev/null 2>&1; then
    nohup qs >/dev/null 2>&1 &
    disown
else
    STATE_FILE="$HOME/.config/quickshell/bar-state.json"
    current=$(jq -r '.barPosition // "top"' "$STATE_FILE" 2>/dev/null || echo "top")
    new="bottom"
    [ "$current" = "bottom" ] && new="top"
    printf '{"barPosition": "%s"}\n' "$new" > "$STATE_FILE"
fi
