{ config, pkgs, nixpkgs-beta, nixpkgs-unstable, ... }:

let
  beta = import nixpkgs-beta {
    system = pkgs.system or "x86_64-linux";
    config.allowUnfree = true;
  };

  unstable = import nixpkgs-unstable {
    system = pkgs.system or "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.nvidia = {
    package = pkgs.linuxKernel.packages.linux_6_17.nvidia_x11;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
  };
}