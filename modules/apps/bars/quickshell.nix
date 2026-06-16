{ pkgs, ... }:

{
  home.packages = [
    pkgs.quickshell
    pkgs.jq
    pkgs.inotify-tools
  ];

  home.file.".config/quickshell" = {
    source = builtins.filterSource (
      path: type: builtins.baseNameOf path != ".qmlls.ini"
    ) ../../../resources/quickshell;
    recursive = true;
  };
}
