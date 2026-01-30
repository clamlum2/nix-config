#/usr/bin/env bash

set -euo pipefail

OPERATION="$1"

if [ "$(playerctl status -p spotify)" == "No players found" ]; then
    playerctl volume 0.05"$OPERATION"
else
    playerctl volume -p spotify 0.05"$OPERATION"
fi