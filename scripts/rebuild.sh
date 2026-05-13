#!/usr/bin/env bash
set -euo pipefail

CONFIG_REPO="$HOME/nix-config"
KERNEL_SCRIPT="$CONFIG_REPO/cachyos-kernel/scripts/update-kernel.sh"

usage() {
    cat <<EOF
Usage: $(basename "$0") [-u] [-k] [-a <action>] [-h <hostname>] [--help]
Options:
  -u             Run 'nix flake update' and git pull before rebuilding
  -k             Run kernel update script before rebuilding
  -s             Use stable kernel releases only (requires -k)
  -a <action>    nixos-rebuild action (default: test)
  -h <hostname>  Override hostname (default: current hostname)
  --help             Show this help
EOF
}

for arg in "$@"; do
    if [[ "$arg" == "--help" ]]; then
        usage
        exit 0
    fi
done

UPGRADE=0
KERNEL=0
STABLE=0
ACTION="test"
HOSTNAME=$(hostname)

while getopts ":uksa:h:" opt; do
    case "$opt" in
        u) UPGRADE=1 ;;
        k) KERNEL=1 ;;
        s) STABLE=1 ;;
        a) ACTION="$OPTARG" ;;
        h) HOSTNAME="$OPTARG" ;;
        :)
            echo "Error: -$OPTARG requires an argument"
            usage
            exit 2
            ;;
        \?)
            echo "Unknown flag: -$OPTARG"
            usage
            exit 2
            ;;
    esac
done

if [[ ! -d "$CONFIG_REPO" ]]; then
    echo "Error: config repo '$CONFIG_REPO' not found"
    exit 1
fi

if [[ "$KERNEL" -eq 1 ]]; then
    if [[ ! -x "$KERNEL_SCRIPT" ]]; then
        echo "Error: kernel update script not found at $KERNEL_SCRIPT"
        exit 1
    fi
    echo "==> Running kernel update"
    if [[ "$STABLE" -eq 1 ]]; then
        "$KERNEL_SCRIPT" -s
    else
        "$KERNEL_SCRIPT"
    fi
    echo "==> Kernel update complete"
elif [[ "$STABLE" -eq 1 ]]; then
    echo "Warning: -s has no effect without -k"
fi

if [[ "$UPGRADE" -eq 1 ]]; then
    echo "==> Updating flake in $CONFIG_REPO"
    cd "$CONFIG_REPO"
    git pull
    nix flake update
    echo "==> Flake update complete"
fi

echo "Using hostname: $HOSTNAME"

rebuild_start=$(date +%s)
if sudo nixos-rebuild $ACTION --flake "$CONFIG_REPO#$HOSTNAME"; then
    rebuild_elapsed=$(( $(date +%s) - rebuild_start ))
    echo "==> Rebuild/$ACTION complete in $(( rebuild_elapsed / 60 ))m $(( rebuild_elapsed % 60 ))s"
else
    echo "Error: nixos-rebuild failed"
    exit 1
fi
