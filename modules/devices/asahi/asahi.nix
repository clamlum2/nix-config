{ pkgs,inputs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "asahi";
  networking.networkmanager.wifi.backend = "iwd";

  services.libinput.enable = true;

  system.stateVersion = "26.11";

  imports = [
    inputs.apple-silicon-support.nixosModules.apple-silicon-support
  ];

  nixpkgs.overlays = [ inputs.apple-silicon-support.overlays.apple-silicon-overlay ];

  hardware.asahi.enable = true;

  hardware.apple.touchBar = {
    enable = true;
    package = pkgs.tiny-dfr;
  };

  hardware.asahi.peripheralFirmwareDirectory = inputs.asahi-firmware;

  environment.systemPackages = [
    pkgs.brightnessctl
    pkgs.btop
  ];

  services.upower.enable = true;

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;
}
