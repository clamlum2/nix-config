{ pkgs, ... }:

{
  home.packages = [
    pkgs.qt6Packages.qtstyleplugin-kvantum
  ];

  xdg.configFile."Kvantum/Amy-Dark-Kvantum" = {
    source = /etc/nixos/resources/Amy-Dark-Kvantum;
    recursive = true;
  };

  xdg.configFile."Kvantum/kvantum.kconfig".text = ''
    [General]
    theme=Amy-Dark-Kvantum
  '';

  home.file.".config/dolphinrc".text = ''
    [UiSettings]
    ColorScheme=Kvantum
  '';
}
