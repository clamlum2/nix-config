#!/usr/bin/env bash
set -euo pipefail

result=""

while true; do
    if [ -n "$result" ]; then
        lines=1
    else
        lines=0
    fi

  expr="$(
    printf '%s\n' "$result" \
    | fuzzel --dmenu \
        --prompt='calc > ' \
        --lines="$lines" \
        --width=50

  )"

  wl-copy "$expr"

  result="$(printf '%s\n' "$expr" | bc -l 2>/dev/null || true)"
  echo "$result"
done
