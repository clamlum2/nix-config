{ config, pkgs, ... }:

{
  home.file.".ssh/id_ed25519".source = /etc/nixos/resources/ssh/id_ed25519;
  home.file.".ssh/id_ed25519.pub".source = /etc/nixos/resources/ssh/id_ed25519.pub;
}