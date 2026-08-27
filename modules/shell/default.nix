{ username, ... }:

{
  home-manager.users.${username}.imports = [
    ./zsh.nix
    ./themes/blue.nix
    ./git.nix
    ./nix-shell.nix
  ];
}
