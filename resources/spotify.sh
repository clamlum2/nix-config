#!/usr/bin/env sh
set -e

SPOTIFY_URL="https://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.2.63.394.g126b0d89_amd64.deb"

mkdir -p ~/spotify
cd ~/spotify

wget -O spotify.deb "$SPOTIFY_URL"

ar x spotify.deb
tar -xf data.tar.gz

rm control.tar.gz data.tar.gz spotify.deb debian-binary spotify

ln -s ~/spotify/usr/share/spotify/spotify ~/spotify

rm -f ~/.local/share/applications/spotify.desktop
touch ~/.local/share/applications/spotify.desktop
cat > ~/.local/share/applications/spotify.desktop <<EOF
[Desktop Entry]
Name=Spotify
Comment=Spotify Music Player
Exec=/home/clamt/spotify/spotify
Icon=/home/clamt/spotify/usr/share/spotify/icons/spotify-linux-512.png
Terminal=false
Type=Application
EOF

tag="${1:-}"

releases_uri="https://github.com/spicetify/cli/releases"
target="linux-amd64"

if [ -z "$tag" ]; then
    tag=$(curl -LsH 'Accept: application/json' $releases_uri/latest | grep -o '"tag_name":"[^"]*' | grep -o '[^"]*$')
fi
tag=${tag#v}

echo "Installing Spicetify version $tag"

install_dir="$HOME/.spicetify"
mkdir -p "$install_dir"
curl -L --fail --output "$install_dir/spicetify.tar.gz" "$releases_uri/download/v$tag/spicetify-$tag-$target.tar.gz"
tar xzf "$install_dir/spicetify.tar.gz" -C "$install_dir"
chmod +x "$install_dir/spicetify"
rm "$install_dir/spicetify.tar.gz"

echo "Spicetify installed at $install_dir/spicetify"

SPICETIFY_CONFIG_DIR="$HOME/.config/spicetify"
INSTALL_DIR="$SPICETIFY_CONFIG_DIR/CustomApps"
MARKETPLACE_DIR="$INSTALL_DIR/marketplace"
TMP_DIR="$INSTALL_DIR/marketplace-tmp"
ZIP_FILE="$INSTALL_DIR/marketplace-dist.zip"
DEFAULT_COLOR_URI="https://raw.githubusercontent.com/spicetify/marketplace/main/resources/color.ini"

releases_uri="https://github.com/spicetify/marketplace/releases"
tag=$(curl -LsH 'Accept: application/json' $releases_uri/latest | grep -o '"tag_name":"[^"]*' | grep -o '[^"]*$')
tag=${tag#v}

download_uri="$releases_uri/download/v$tag/marketplace.zip"
mkdir -p "$INSTALL_DIR"
curl -L --fail --output "$ZIP_FILE" "$download_uri"
unzip -q -d "$TMP_DIR" -o "$ZIP_FILE"
rm -rf "$MARKETPLACE_DIR"
mv "$TMP_DIR/marketplace-dist" "$MARKETPLACE_DIR"
rm -rf "$ZIP_FILE" "$TMP_DIR"

spicetify config custom_apps marketplace
spicetify config inject_css 1
spicetify config replace_colors 1

current_theme=$(spicetify config current_theme)
if [ ${#current_theme} -le 3 ]; then
    mkdir -p "$SPICETIFY_CONFIG_DIR/Themes/marketplace"
    curl -L --fail --output "$SPICETIFY_CONFIG_DIR/Themes/marketplace/color.ini" "$DEFAULT_COLOR_URI"
    spicetify config current_theme marketplace
fi

SPOTIFY_PATH="$HOME/spotify/usr/share/spotify"
CONFIG_FILE="$HOME/.config/spicetify/config-xpui.ini"
sed -i "s|^spotify_path[[:space:]]*=.*|spotify_path           = $SPOTIFY_PATH|" "$CONFIG_FILE"

spicetify apply