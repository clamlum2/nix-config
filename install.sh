REPO_URL_HTTPS="https://github.com/clamlum2/nix-config.git"
REPO_URL_SSH="git@github.com:clamlum2/nix-config.git"
CURRENT_URL=$(git config --get remote.origin.url 2>/dev/null)

if [ "$CURRENT_URL" = "$REPO_URL_HTTPS" ] || [ "$CURRENT_URL" = "$REPO_URL_SSH" ]; then
    sudo rsync -av --exclude='.git' --exclude='README.md' "$CONFIG_DIR/" /etc/nixos/
    sudo nixos-rebuild switch --profile-name "config updated"
    reboot
else
    cd ~
    git clone "$REPO_URL_HTTPS"
    cd nix-config
    sudo rsync -av --exclude='.git' --exclude='README.md' --exclude='install.sh' "$CONFIG_DIR/" /etc/nixos/
    sudo nixos-rebuild switch --profile-name "config installed"
    reboot
fi