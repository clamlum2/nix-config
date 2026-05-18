{ pkgs, ... }:

{
  programs.niri = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.swaybg
  ];

  home-manager.users.clamt.home.file.".config/niri/config.kdl".source =
    "${./.}/resources/niri/niri.kdl";
}
