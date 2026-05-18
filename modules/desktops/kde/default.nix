{
  imports = [
    ./kde.nix
  ];

  home-manager.users.clamt.imports = [
    ./plasma-manager.nix
  ];
}
