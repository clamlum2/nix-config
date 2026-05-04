{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.git
    pkgs.ghostty.terminfo
  ];
}
