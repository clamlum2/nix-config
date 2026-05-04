{ ... }:

{
  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "25.11";

  home.file.".zshrc".text = ''
    export HOST=$(hostname)
  '';
}
