REPO_URL="https://github.com/clamlum2/nix-config.git"
CONFIG_DIR="$HOME/nix-config"
BRANCH="${1:-main}"

if [ -d "$CONFIG_DIR/.git" ]; then
    echo "Repo found at $CONFIG_DIR. Updating..."
    cd "$CONFIG_DIR" || { echo "Failed to cd to $CONFIG_DIR"; exit 1; }
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    echo "On branch: $CURRENT_BRANCH"
    git pull origin "$CURRENT_BRANCH"
    sudo rsync -av --exclude='.git' --exclude='README.md' --exclude='install.sh' "$CONFIG_DIR/" /etc/nixos/
    sudo nixos-rebuild switch --profile-name "config updated ($CURRENT_BRANCH)"
    hyprshade on extravibrance
else
    echo "Repo not found. Cloning branch '$BRANCH' to $CONFIG_DIR..."
    git clone --branch "$BRANCH" "$REPO_URL" "$CONFIG_DIR"
    cd "$CONFIG_DIR" || { echo "Failed to cd to $CONFIG_DIR"; exit 1; }
    sudo rsync -av --exclude='.git' --exclude='README.md' --exclude='install.sh' "$CONFIG_DIR/" /etc/nixos/
    sudo nixos-rebuild switch --profile-name "config installed ($BRANCH)"
    hyprshade on extravibrance
fi