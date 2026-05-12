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
ACTION="test"
HOSTNAME=$(hostname)

while getopts ":uka:h:" opt; do
    case "$opt" in
        u) UPGRADE=1 ;;
        k) KERNEL=1 ;;
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


if [[ "$UPGRADE" -eq 1 ]]; then
    echo "==> Updating flake in $CONFIG_REPO"
    cd "$CONFIG_REPO"
    git pull
    nix flake update
    echo "==> Flake update complete"
fi

if [[ "$KERNEL" -eq 1 ]]; then
    if [[ ! -x "$KERNEL_SCRIPT" ]]; then
        echo "Error: kernel update script not found at $KERNEL_SCRIPT"
        exit 1
    fi
    echo "==> Running kernel update"
    "$KERNEL_SCRIPT"
    echo "==> Kernel update complete"
fi

echo "Using hostname: $HOSTNAME"

echo "==> Rebuild/$ACTION system for flake: $CONFIG_REPO#$HOSTNAME"
if sudo nixos-rebuild $ACTION --flake "$CONFIG_REPO#$HOSTNAME"; then
    echo "==> Rebuild/$ACTION complete"
else
    echo "Error: nixos-rebuild failed"
    exit 1
fi
