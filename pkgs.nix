{ pkgs, nixpkgs-unstable, ... }:

let
  unstable = import nixpkgs-unstable {
    system = pkgs.system or "x86_64-linux";
    config.allowUnfree = true;
  };
in

{
    environment.systemPackages = [
    pkgs.kitty
    pkgs.git
    pkgs.google-chrome
    pkgs.kdePackages.dolphin
    pkgs.polkit
    pkgs.polkit_gnome
    pkgs.hyprpaper
    pkgs.hyprshade
    pkgs.pwvucontrol
    pkgs.curl
    pkgs.p7zip
    pkgs.kdePackages.qtstyleplugin-kvantum
    pkgs.libsForQt5.qtstyleplugin-kvantum
    pkgs.qt6ct
    pkgs.libsForQt5.qt5ct
    pkgs.glib
    pkgs.gsettings-desktop-schemas
    pkgs.hyprpicker
    pkgs.playerctl
    pkgs.grim
    pkgs.wl-clipboard
    pkgs.slurp
    pkgs.ncdu
    pkgs.xdg-desktop-portal
    pkgs.xdgmenumaker
    pkgs.kdePackages.kservice
    pkgs.libxcvt
    pkgs.alsa-utils
    pkgs.dysk
    pkgs.hyprlock
    pkgs.qbittorrent
    pkgs.mpv
    pkgs.oh-my-zsh
    pkgs.kdePackages.ark
    pkgs.obs-studio
    pkgs.remmina
    pkgs.gnome-themes-extra
    pkgs.jq
    pkgs.steam-run
    pkgs.slack
    pkgs.fuse
    pkgs.appimage-run
    pkgs.nix-prefetch-git
    pkgs.grimblast
    pkgs.python313Packages.gpustat
    pkgs.iperf3
    pkgs.localsend
    pkgs.nextcloud-client
    pkgs.easyeffects

    unstable.discord
    unstable.vscode

    pkgs.vesktop-with-wayland

    (import ./imports/helium.nix { inherit pkgs; icon = ./resources/icons/helium.png; })
  ];

  nixpkgs.overlays = [
    (import ./overlays/vesktop.nix)
  ];
}