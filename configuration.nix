{ config, pkgs, nixpkgs-unstable, ... }:

let
  unstable = import nixpkgs-unstable {
    system = pkgs.system or "x86_64-linux";
    config.allowUnfree = true;
  };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./imports/nix-ld.nix

      ./imports/laptop.nix
    ];

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
    packages = [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.kitty
    pkgs.git
    pkgs.fastfetch
    pkgs.google-chrome
    pkgs.kdePackages.dolphin
    pkgs.polkit
    pkgs.polkit_gnome
    pkgs.hyprpaper
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
    pkgs.mpv
    pkgs.oh-my-zsh
    pkgs.kdePackages.ark
    pkgs.obs-studio
    pkgs.remmina
    pkgs.gnome-themes-extra
    pkgs.jq
    pkgs.steam-run
    pkgs.btop
    pkgs.slack
    pkgs.fuse
    pkgs.appimage-run
    pkgs.nix-prefetch-git
    pkgs.grimblast
    pkgs.python313Packages.gpustat
    pkgs.iperf3
    pkgs.localsend
    pkgs.vesktop

    unstable.discord
    unstable.vscode
    unstable.spotify

    (import ./imports/helium.nix { inherit pkgs; icon = ./resources/icons/helium.png; })
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
    # extraConfig = {
    #   "pipewire" = {
    #     "default.clock.rate" = 48000;
    #     "default.clock.quantum" = 1024;
    #   };
    # };
  };

  fonts.packages = [
    pkgs.nerd-fonts.noto
    pkgs.nerd-fonts.dejavu-sans-mono
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  };

  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  services.udisks2.enable = true;

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.gvfs.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
