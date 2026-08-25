{ pkgs, inputs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "asahi";
  # networking.networkmanager.wifi.backend = "iwd";

  services.libinput.enable = true;

  system.stateVersion = "26.11";

  imports = [
    inputs.apple-silicon-support.nixosModules.apple-silicon-support
  ];

  nixpkgs.overlays = [ inputs.apple-silicon-support.overlays.apple-silicon-overlay ];

  hardware.asahi.enable = true;

  hardware.apple.touchBar = {
    enable = true;
    package = inputs.not-quite-tiny-dfr.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  hardware.asahi.peripheralFirmwareDirectory = inputs.asahi-firmware;

  environment.systemPackages = [
    pkgs.brightnessctl
    pkgs.btop
    pkgs.distrobox
  ];

  services.upower.enable = true;

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  services.cloudflare-warp.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "lock";
    HandlePowerKey = "suspend";

    IdleAction = "suspend";
    IdleActionSec = "5min";
  };

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "15min";
  };
}
