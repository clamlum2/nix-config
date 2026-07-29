{ pkgs, username, inputs, ... }:

{
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.swaybg
    pkgs.wtype
  ];

  home-manager.users.${username}.home.file.".config/niri/config.kdl".source =
    ../../../resources/niri/niri.kdl;
}
