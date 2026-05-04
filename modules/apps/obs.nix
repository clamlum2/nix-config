{ pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.libva-vdpau-driver
    pkgs.libva-utils
    pkgs.ffmpeg-full
  ];
}
