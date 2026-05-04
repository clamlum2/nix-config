{ pkgs, repoRoot, ... }:

{
  home.packages = [
    pkgs.quickshell
    pkgs.jq
  ];

  home.file.".config/quickshell" = {
    source = "${repoRoot}/resources/quickshell";
    recursive = true;
  };
}
