{ pkgs, ... }:

{
  home.packages = [
    pkgs.micro
  ];

  home.file.".config/micro/colorschemes/custom.micro".source = ../../resources/micro/blue.micro;
  home.file.".config/micro/settings.json".source = ../../resources/micro/settings.json;
}
