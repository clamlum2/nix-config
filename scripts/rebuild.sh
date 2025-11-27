#!/usr/bin/env bash
set -euo pipefail

CONFIG_REPO=/etc/nixos

if [[ -n "${SUDO_USER:-}" ]]; then
    SRC_REPO="/home/${SUDO_USER}/nix-config"
else
    SRC_REPO="$HOME/nix-config"
fi

usage() {
    cat <<EOF
Usage: $(basename "$0") [--upgrade] [--help]

Options:
  --upgrade    Run 'nix flake update' in $CONFIG_REPO and then upgrade the system
  -h, --help   Show this help
EOF
}

UPGRADE=0
ACTION="test"
while [[ ${#} -gt 0 ]]; do
    case "$1" in
        -a|--action)
            if [[ $# -lt 2 ]]; then
                echo "Error: --action requires an argument"
                usage
                exit 2
            fi
            ACTION="$2"
            shift 2
            ;;
        -u|--upgrade)
            UPGRADE=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1"
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
    echo "==> Updating flake (preferred: $SRC_REPO, fallback: $CONFIG_REPO)"
    UPDATE_OK=0

    if [[ -d "$SRC_REPO" ]]; then
        if [[ -n "${SUDO_USER:-}" ]]; then
            echo "==> Running 'nix flake update' as ${SUDO_USER} in $SRC_REPO"
            if sudo -u "${SUDO_USER}" bash -c "cd '$SRC_REPO' && nix flake update"; then
                UPDATE_OK=1
            else
                echo "Warning: 'nix flake update' in $SRC_REPO as ${SUDO_USER} failed"
            fi
        else
            echo "==> Running 'nix flake update' in $SRC_REPO"
            if (cd "$SRC_REPO" && nix flake update); then
                UPDATE_OK=1
            else
                echo "Warning: 'nix flake update' in $SRC_REPO failed"
            fi
        fi
    else
        echo "Note: source repo '$SRC_REPO' not found; will try updating $CONFIG_REPO as root"
    fi

    if [[ "$UPDATE_OK" -ne 1 ]]; then
        echo "==> Trying to update flake in $CONFIG_REPO as root"
        if sudo bash -c "cd '$CONFIG_REPO' && nix flake update"; then
            UPDATE_OK=1
        else
            echo "Warning: 'nix flake update' in $CONFIG_REPO (as root) failed"
        fi
    fi

    if [[ "$UPDATE_OK" -ne 1 ]]; then
        echo "Error: 'nix flake update' failed in both $SRC_REPO and $CONFIG_REPO"
        exit 1
    fi

    echo "==> Flake update complete"
fi

if [[ -d "$SRC_REPO" ]]; then
    echo "==> Syncing $SRC_REPO -> $CONFIG_REPO"
    if ! sudo rsync -av --exclude='.git' --exclude='README.md' --exclude='install.sh' "$SRC_REPO/" "$CONFIG_REPO/"; then
        echo "Error: rsync from '$SRC_REPO' to '$CONFIG_REPO' failed"
        exit 1
    fi
    echo "==> Sync complete"
else
    echo "Warning: source repo '$SRC_REPO' not found; skipping sync"
fi

HOST=$(hostname)

if [[ "$HOST" == "unknown" ]]; then
    echo "Error: Could not determine valid hostname (branch: '${BRANCH:-unset}')"
    exit 1
fi

echo "Using hostname: $HOST"

echo "==> Rebuilding system for flake: $CONFIG_REPO#$HOST"
if sudo nixos-rebuild $ACTION --flake "$CONFIG_REPO#$HOST"; then
    echo "==> Rebuild/$ACTION complete"
    if command -v hyprshade >/dev/null 2>&1; then
        echo "==> Restoring hyprshade"
        hyprshade on extravibrance || true
    fi
else
    echo "Error: nixos-rebuild failed"
    exit 1
fi