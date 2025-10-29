#!/usr/bin/env bash
set -euo pipefail

# Define your config repo path
CONFIG_REPO=/etc/nixos

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

# Check if hostname is valid
if [[ ! " ${VALID_HOSTS[@]} " =~ " ${HOST} " ]]; then
    # Hostname is invalid or not set, get git branch
    BRANCH=$(git -C "$CONFIG_REPO" rev-parse --abbrev-ref HEAD)
    HOST=$(map_branch_to_host "$BRANCH")
fi

if [[ "$HOST" == "unknown" ]]; then
    echo "Error: Could not determine valid hostname from branch '$BRANCH'"
    exit 1
fi

echo "Using hostname: $HOST"
sudo nixos-rebuild switch --flake "$CONFIG_REPO#$HOST"