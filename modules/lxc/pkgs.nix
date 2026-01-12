{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.git
  ];
}