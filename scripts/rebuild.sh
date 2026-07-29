#!/usr/bin/env bash
set -euo pipefail

CONFIG_REPO="$HOME/nix-config"
KERNEL_SCRIPT="$CONFIG_REPO/cachyos-kernel/scripts/update-kernel.sh"

usage() {
    cat <<EOF
Usage: $(basename "$0") [-u] [-a <action>] [-h <hostname>] [--help]
Options:
  -u             Run 'nix flake update' and git pull before rebuilding
  -g             Run garbage collection after rebuilding
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
GC=0
ACTION="test"
HOSTNAME=$(hostname)
OS="$(uname -s)"

while getopts ":uksga:h:" opt; do
    case "$opt" in
        u) UPGRADE=1 ;;
        k) KERNEL=1 ;;
        s) STABLE=1 ;;
        g) GC=1 ;;
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
    echo "==> Updating $CONFIG_REPO"
    cd "$CONFIG_REPO"
    git pull
    echo "==> Updating flake in $CONFIG_REPO"
    nix flake update
    echo "==> Flake update complete"
fi

case "$OS" in
    Darwin)
        echo "==> Running on macOS"
        HOSTNAME="macbook"
        COMMAND="darwin-rebuild"
        ;;
    Linux)
        echo "==> Running on Linux"
        COMMAND="nixos-rebuild"
        ;;
    *)
        echo "Unknown OS: $OS"
        exit 1
        ;;
esac

echo "Using hostname: $HOSTNAME"


rebuild_start=$(date +%s)
if sudo $COMMAND $ACTION --flake "$CONFIG_REPO#$HOSTNAME"; then
    rebuild_elapsed=$(( $(date +%s) - rebuild_start ))
    echo "==> Rebuild/$ACTION complete in $(( rebuild_elapsed / 60 ))m $(( rebuild_elapsed % 60 ))s"
else
    echo "Error: $COMMAND failed"
    exit 1
fi

if [[ "$GC" -eq 1 ]]; then
    echo "==> Running garbage collection"
    sudo nix-collect-garbage -d 2>/dev/null | tail -n 1
    nix-collect-garbage -d 2>/dev/null | tail -n 1
    echo "==> Garbage collection complete"
fi
