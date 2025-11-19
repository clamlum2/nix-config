#!/usr/bin/env bash
set -euo pipefail

# Define your config repo path
CONFIG_REPO=/etc/nixos

# Default source repo (where your editable nix-config lives). If this
# script is invoked via sudo the original user is available in SUDO_USER
# so prefer their home directory.
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

# Parse arguments
UPGRADE=0
while [[ ${#} -gt 0 ]]; do
    case "$1" in
        --upgrade)
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

# Basic checks
if [[ ! -d "$CONFIG_REPO" ]]; then
    echo "Error: config repo '$CONFIG_REPO' not found"
    exit 1
fi

# If requested, update the flake. Prefer updating the user's editable copy
# ("$SRC_REPO"). This allows a regular user to update lockfiles in their
# home directory, and we then rsync the updated files into $CONFIG_REPO. If
# that isn't possible we'll fall back to running the update in
# $CONFIG_REPO as root (requires sudo) which is what triggered your
# permission error.
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

# Sync local repo into $CONFIG_REPO (moved from the shell alias so flags like
# --upgrade are handled correctly). Uses sudo for the copy so it works when
# writing to /etc/nixos.
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

# Get current hostname
HOST=$(hostname)

# Define valid hostnames
VALID_HOSTS=("nixos" "laptop")

# Function to map git branch to hostname
map_branch_to_host() {
    local branch="$1"
    case "$branch" in
        main) echo "nixos" ;;
        laptop) echo "laptop" ;;
        *) echo "unknown" ;;
    esac
}

# Check if hostname is valid; if not, try to infer from git branch
if [[ ! " ${VALID_HOSTS[@]} " =~ " ${HOST} " ]]; then
    BRANCH=$(git -C "$CONFIG_REPO" rev-parse --abbrev-ref HEAD || true)
    HOST=$(map_branch_to_host "$BRANCH")
fi

if [[ "$HOST" == "unknown" ]]; then
    echo "Error: Could not determine valid hostname (branch: '${BRANCH:-unset}')"
    exit 1
fi

echo "Using hostname: $HOST"

# Finally, perform the rebuild/switch. This mirrors the previous behaviour.
echo "==> Rebuilding system for flake: $CONFIG_REPO#$HOST"
if sudo nixos-rebuild switch --flake "$CONFIG_REPO#$HOST"; then
    echo "==> Rebuild/switch complete"
    # Restore the visual effect if hyprshade is available (moved from alias)
    if command -v hyprshade >/dev/null 2>&1; then
        echo "==> Restoring hyprshade"
        # don't fail the whole script if hyprshade fails
        hyprshade on extravibrance || true
    fi
else
    echo "Error: nixos-rebuild failed"
    exit 1
fi