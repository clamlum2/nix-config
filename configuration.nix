{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
  };
  nixpkgs-unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") { config = { allowUnfree = true; }; };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")

      ./imports/pc.nix

      ./imports/device.nix
    ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.clamt = import ./home.nix;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/sda";
  #boot.loader.grub.useOSProber = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_NZ.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_NZ.UTF-8";
    LC_IDENTIFICATION = "en_NZ.UTF-8";
    LC_MEASUREMENT = "en_NZ.UTF-8";
    LC_MONETARY = "en_NZ.UTF-8";
    LC_NAME = "en_NZ.UTF-8";
    LC_NUMERIC = "en_NZ.UTF-8";
    LC_PAPER = "en_NZ.UTF-8";
    LC_TELEPHONE = "en_NZ.UTF-8";
    LC_TIME = "en_NZ.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.clamt = {
    isNormalUser = true;
    description = "clam";
    extraGroups = [ "networkmanager" "wheel" "video" "render" "input" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pkgs.kitty  
    pkgs.hyprland 
    pkgs.git
    pkgs.fastfetch
    pkgs.google-chrome
    pkgs.wofi
    pkgs.kdePackages.dolphin
    pkgs.polkit
    pkgs.polkit_gnome
    pkgs.hyprpaper
    pkgs.vesktop
    pkgs.hyprshade
    pkgs.pwvucontrol
    pkgs.easyeffects
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
    pkgs.wezterm
    pkgs.mpv
    pkgs.oh-my-zsh
    pkgs.kdePackages.ark
    pkgs.obs-studio 

    nixpkgs-unstable.ghostty
    nixpkgs-unstable.spotify
    nixpkgs-unstable.vscode
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 139 445 47984 47989 47990 48010 ];
  networking.firewall.allowedUDPPorts = [ 137 138 47998 47999 48000 48002 48010 ];

  system.stateVersion = "25.05"; 

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;

  users.users."clamt".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH/sXIx+I7BCq6T4QfiEWqvh+E1d9+y4CrTijURf5Wsq clamt"
  ];

  security.polkit.enable = true;

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "Polkit GNOME Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  environment.etc."polkit-1/rules.d/49-remember-auth.rules".text = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("wheel") &&
        action.id == "org.freedesktop.policykit.exec"
      ) {
        return polkit.Result.AUTH_ADMIN_KEEP;
      }
    });
  '';

  powerManagement.cpuFreqGovernor = "performance";
  security.rtkit.enable = true;

  services.tlp.enable = true;
  services.tlp.settings = {
    SOUND_POWER_SAVE_ON_AC = "0";
    SOUND_POWER_SAVE_ON_BAT = "0";
    USB_AUTOSUSPEND = "0";
  };

  services.pipewire = {
    enable = true;
    extraConfig = {
      "pipewire" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
      };
    };
  };

  fonts.packages = [
    pkgs.nerd-fonts.noto
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  };

  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  services.udisks2.enable = true;
}
