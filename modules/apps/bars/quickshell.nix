{ pkgs, ... }:

{
  home.packages = [
    pkgs.quickshell
    pkgs.jq
  ];

  home.file.".config/quickshell" = {
    source = ../../../resources/quickshell;
    recursive = true;
  };
}
