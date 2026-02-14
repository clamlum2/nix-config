{ config, lib, pkgs, ... }:


{
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    nvidiaSettings = true;

    open = true;

    package =
    let
      base = config.boot.kernelPackages.nvidiaPackages.latest;
      cachyos-nvidia-patch = pkgs.fetchpatch {
      url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
        sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
      };
      in
      # Use the // operator to merge the original bundle with your patched open module
      base
      // {
      open = base.open.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [ cachyos-nvidia-patch ];
      });
    };

    # package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  environment.systemPackages = [
    pkgs.btop-cuda
  ];
}
