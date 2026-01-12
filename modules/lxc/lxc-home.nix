{ config, ... }:

{
  home.file.".zshrc".text = ''
    export TERM="xterm-256color"
  '';
}