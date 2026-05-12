#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnumake perl bc flex bison openssl kmod elfutils pahole python3 pkg-config zlib libelf curl git nix
set -e

KERNEL_FLAKE="$HOME/nix-config/cachyos-kernel"
WORK_DIR=$(mktemp -d)
trap "rm -rf $WORK_DIR" EXIT

# Get latest release version from GitHub
echo "Fetching latest CachyOS kernel release..."
LATEST=$(curl -s https://api.github.com/repos/CachyOS/linux/releases | grep '"tag_name"' | head -1 | cut -d'"' -f4)
VERSION=${LATEST#cachyos-}
echo "Latest version: $VERSION"

# Check current version in flake
CURRENT=$(grep 'cachyVersion\s*=' "$KERNEL_FLAKE/flake.nix" | cut -d'"' -f2)
CURRENT_REL=$(grep 'cachyRelease\s*=' "$KERNEL_FLAKE/flake.nix" | cut -d'"' -f2)
CURRENT_FULL="$CURRENT-$CURRENT_REL"

if [ "$VERSION" = "$CURRENT_FULL" ]; then
  echo "Already on latest version $VERSION, nothing to do"
  exit 0
fi

echo "Updating $CURRENT_FULL -> $VERSION"

# Download and extract new source
TARBALL="cachyos-${VERSION}.tar.gz"
URL="https://github.com/CachyOS/linux/releases/download/cachyos-${VERSION}/${TARBALL}"

echo "Downloading $URL..."
curl -L -o "$WORK_DIR/$TARBALL" "$URL"

# Get hash for flake
echo "Getting nix hash..."
HASH=$(nix hash file --type sha256 --base64 "$WORK_DIR/$TARBALL")
HASH="sha256-$HASH"

# Extract source
echo "Extracting..."
tar xf "$WORK_DIR/$TARBALL" -C "$WORK_DIR"
SOURCE_DIR="$WORK_DIR/cachyos-${VERSION}"

# Get modDirVersion from Makefile
MAJOR=$(grep "^VERSION\s*=" "$SOURCE_DIR/Makefile" | awk '{print $3}')
MINOR=$(grep "^PATCHLEVEL\s*=" "$SOURCE_DIR/Makefile" | awk '{print $3}')
PATCH=$(grep "^SUBLEVEL\s*=" "$SOURCE_DIR/Makefile" | awk '{print $3}')
EXTRA=$(grep "^EXTRAVERSION\s*=" "$SOURCE_DIR/Makefile" | awk '{print $3}')
MOD_DIR_VERSION="${MAJOR}.${MINOR}.${PATCH}${EXTRA}-cachyos"
echo "modDirVersion: $MOD_DIR_VERSION"

# Update config
echo "Updating kernel config..."
cp "$KERNEL_FLAKE/config" "$SOURCE_DIR/.config"
make -C "$SOURCE_DIR" olddefconfig

# Show new config options
NEW_OPTS=$(make -C "$SOURCE_DIR" listnewconfig 2>/dev/null)
if [ -n "$NEW_OPTS" ]; then
  echo "New config options set to defaults:"
  echo "$NEW_OPTS"
fi

cp "$SOURCE_DIR/.config" "$KERNEL_FLAKE/config"

# Parse version parts
CACHY_VERSION=$(echo $VERSION | sed 's/-[0-9]*$//')
CACHY_RELEASE=$(echo $VERSION | grep -o '[0-9]*$')

# Update flake.nix
echo "Updating flake.nix..."
sed -i "s|cachyVersion = \".*\"|cachyVersion = \"$CACHY_VERSION\"|" "$KERNEL_FLAKE/flake.nix"
sed -i "s|cachyRelease = \".*\"|cachyRelease = \"$CACHY_RELEASE\"|" "$KERNEL_FLAKE/flake.nix"
sed -i "s|modDirVersion = \".*\"|modDirVersion = \"$MOD_DIR_VERSION\"|" "$KERNEL_FLAKE/flake.nix"
sed -i "s|hash = \"sha256-.*\"|hash = \"$HASH\"|" "$KERNEL_FLAKE/flake.nix"

# Update kernel flake's own nixpkgs lock
echo "Updating kernel flake nixpkgs..."
cd "$KERNEL_FLAKE"
nix flake update

# Update main flake input
echo "Updating main flake lock..."
nix flake update --update-input cachyos-kernel

echo ""
echo "Done! Kernel updated to $VERSION"
echo "Run: nixos-rebuild switch --flake . to apply"
