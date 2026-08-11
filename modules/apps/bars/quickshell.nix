{ pkgs, ... }:

let
  quickshell-wrapped = pkgs.symlinkJoin {
    name = "quickshell-wrapped";
    paths = [ pkgs.quickshell ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/qs --unset QT_QPA_PLATFORMTHEME
      wrapProgram $out/bin/quickshell --unset QT_QPA_PLATFORMTHEME
    '';
  };
in

{
  home.packages = [
    quickshell-wrapped
    pkgs.jq
    pkgs.inotify-tools
  ];

  home.file.".config/quickshell" = {
    source = builtins.filterSource (
      path: type: baseNameOf path != ".qmlls.ini"
    ) ../../../resources/quickshell;
    recursive = true;
  };
}
