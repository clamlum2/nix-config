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
        --prompt='calc ❯ ' \
        --placeholder='Enter expression' \
        --lines="$lines" \
        --width=50

  )"

  result="$(printf '%s\n' "$expr" | bc -l 2>/dev/null || true)"
  wl-copy $result
done
