{ pkgs, ... }:

{
  home.packages = [
    pkgs.quickshell
    pkgs.jq
    pkgs.inotify-tools
  ];

  home.file.".config/quickshell" = {
    source = ../../../resources/quickshell;
    recursive = true;
  };
}
