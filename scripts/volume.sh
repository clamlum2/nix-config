#!/usr/bin/env bash

set -euo pipefail

OPERATION="${1:-}"

if [[ -z "$OPERATION" ]]; then
    echo "usage: $0 [+|-]" >&2
    exit 2
fi

if playerctl -p kpouz status >/dev/null 2>&1; then
    playerctl volume -p kpouz 0.05"$OPERATION"
else
    playerctl volume 0.05"$OPERATION"
fi
