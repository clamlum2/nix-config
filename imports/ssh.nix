{ config, pkgs, ... }:

{
  home.file.".ssh/id_ed25519".source = ./../resources/ssh/id_ed25519;
  home.file.".ssh/id_ed25519.pub".source = ./../resources/ssh/id_ed25519.pub;
}