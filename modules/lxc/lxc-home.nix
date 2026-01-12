{ config, ... }:

{
  home.file.".zshrc".text = ''
    export HOST=$(hostname)
  '';
}