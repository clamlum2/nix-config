#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$HOME/.config/quickshell"
LINK="$CONFIG_DIR/shell.qml"
TOP="$CONFIG_DIR/shell_top.qml"
BOTTOM="$CONFIG_DIR/shell_bottom.qml"

if [ ! -f "$TOP" ] || [ ! -f "$BOTTOM" ]; then
  exit 2
fi

curr=""
if [ -L "$LINK" ]; then
  curr="$(readlink -f "$LINK")"
elif [ -e "$LINK" ]; then
  backup="$LINK.bak"
  mv -- "$LINK" "$backup"
fi

target="$TOP"
if [ -n "$curr" ]; then
  if [ "$(readlink -f "$TOP")" = "$curr" ]; then
    target="$BOTTOM"
  else
    target="$TOP"
  fi
fi

ln -sfn -- "$target" "$LINK"

pkill .quickshell-wra || true
qs &
sleep 0.5
touch ~/.config/quickshell/shell.qml

exit 0
