{ pkgs, username, ... }:

{
  programs.niri = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.swaybg
    pkgs.wtype
  ];

  home-manager.users.${username}.home.file.".config/niri/config.kdl".source =
    ../../../resources/niri/niri.kdl;
}
