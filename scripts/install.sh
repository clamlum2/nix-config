#!/usr/bin/env bash

set -euo pipefail

DISK=""
HOSTNAME="nixos"
BRANCH="main"
SWAP_SIZE="0"
SKIP_INSTALL=false
NO_ROOT_PASSWD=false

usage() {
    cat <<EOF
Usage: $(basename "$0") [--disk <disk>] [--branch <branch>] [--hostname <hostname>] [--swap <size>] [--help]

Options:
    --branch            Specify the configuration branch to use (default: main)
    --disk              Specify the target disk for installation (e.g., /dev/sda)
    --hostname          Specify the hostname for the new installation (default: nixos)
    --swap              Specify the swap size in gigabytes (e.g., 4 for 4GB, defaults to no swap)
    --skip-install      Skip the NixOS installation step (for further customization)
    --no-root-passwd    Do not set a root password during installation
  -h, --help   Show this help
EOF
}


while [[ $# -gt 0 ]]; do
	case $1 in
		-b|--branch)
			BRANCH="$2"
			shift 2
			;;
		-d|--disk)
			DISK="$2"
			shift 2
			;;
        -h|--hostname)
            HOSTNAME="$2"
            shift 2
            ;;
        -s|--swap)
            SWAP_SIZE="$2"
            shift 2
            ;;
        -i|--skip-install)
            SKIP_INSTALL=true
            shift 1
            ;;
        -p|--no-root-passwd)
            NO_ROOT_PASSWD=true
            shift 1
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Error: Unknown argument: $1"
            usage
			exit 1
			;;
	esac
done

if [[ -z "$DISK" ]]; then
    echo "Error: --disk argument is required."
    usage
    exit 1
fi

echo "Installing NixOS on disk: $DISK"
echo "Using hostname: $HOSTNAME"
echo "Using configuration branch: $BRANCH"

echo "Partitioning disk $DISK"

umount -R /mnt || true
swapoff -a || true

parted -s $DISK -- mklabel gpt

parted -s "$DISK" -- mkpart ESP fat32 1MiB 1025MiB
parted -s "$DISK" -- set 1 esp on

if [[ "$SWAP_SIZE" != "0" ]]; then
    echo "Swap enabled: ${SWAP_SIZE}GiB"

    parted -s "$DISK" -- mkpart primary 1025MiB -"${SWAP_SIZE}GiB"

    parted -s "$DISK" -- mkpart swap linux-swap -"${SWAP_SIZE}GiB" 100%
else
    echo "Swap disabled"

    parted -s "$DISK" -- mkpart primary 1025MiB 100%
fi

mkfs.fat -F 32 -n boot "${DISK}1"
mkfs.ext4 -FL nixos "${DISK}2"

if [[ "$SWAP_SIZE" != "0" ]]; then
    mkswap -L swap "${DISK}3"
fi

partprobe /dev/sda

mount /dev/disk/by-label/nixos /mnt

mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

if [[ "$SWAP_SIZE" != "0" ]]; then
    swapon "${DISK}3"
fi

mkdir -p /mnt/etc/nixos

git clone --branch "$BRANCH" https://github.com/clamlum2/nix-config.git /mnt/etc/nixos

if [[ $SKIP_INSTALL = true ]]; then
    echo "Skipping NixOS installation as per user request."
    exit 0
fi

export NIX_CONF_DIR=$(mktemp -d)
cat > $NIX_CONF_DIR/nix.conf <<EOF
substituters = https://attic.xuyh0120.win/lantian
trusted-public-keys = lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=
EOF

if [[ "$NO_ROOT_PASSWD" = true ]]; then
    nixos-install --no-root-passwd --flake /mnt/etc/nixos#"$HOSTNAME"
else
    nixos-install --flake /mnt/etc/nixos#"$HOSTNAME"
fi