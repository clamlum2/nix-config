{ config, ... }:

{
  home.file.".zshrc".text = ''
    cd ~
  '';
}