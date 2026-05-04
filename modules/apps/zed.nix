{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.zed-editor
    pkgs.nil
    pkgs.nixd
    pkgs.kdePackages.qtdeclarative
  ];
}
