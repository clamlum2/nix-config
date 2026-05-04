{ pkgs, repoRoot, ... }:

{
  home.packages = [
    pkgs.micro
  ];

  home.file.".config/micro/colorschemes/custom.micro".source =
    "${repoRoot}/resources/micro/blue.micro";
  home.file.".config/micro/settings.json".source = "${repoRoot}/resources/micro/settings.json";
}
