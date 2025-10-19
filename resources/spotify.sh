#!/usr/bin/env bash
set -euo pipefail

MODE=${1:-}
if [[ "$MODE" != "prev" && "$MODE" != "next" ]]; then
  echo "Usage: $0 prev|next" >&2
  exit 2
fi

have() { command -v "$1" >/dev/null 2>&1; }

focused="$(hyprctl activewindow 2>/dev/null || true)"
if [[ -z "$focused" ]]; then
  exit 0
fi

# Extract useful fields
class=$(echo "$focused" | awk -F': ' '/class/{print $2; exit}' | tr '[:upper:]' '[:lower:]' || true)
title=$(echo "$focused" | awk -F': ' '/title/{print $2; exit}' || true)
appId=$(echo "$focused" | awk -F': ' '/appId/{print $2; exit}' | tr '[:upper:]' '[:lower:]' || true)

is_spotify=false
if [[ -n "$class" && "$class" == *spotify* ]]; then
  is_spotify=true
elif [[ -n "$title" && "$title" == *Spotify* ]]; then
  is_spotify=true
elif [[ -n "$appId" && "$appId" == *spotify* ]]; then
  is_spotify=true
fi

if [[ "$is_spotify" != true ]]; then
  exit 0
fi

if have playerctl; then
  if [[ "$MODE" == "prev" ]]; then
    playerctl --player=spotify previous
  else
    playerctl --player=spotify next
  fi
  exit 0
fi

exit 0