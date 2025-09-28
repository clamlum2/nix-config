{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    extraConfig = ''
      background_opacity 0.8
      background #0d1520
    '';
  };
}
