{ device, ... }:
{
  imports = [
    ./kopuz.nix
    ./vesktop.nix
    ./zed.nix

    ./terminals
  ]
  ++ (
    if device == "nixos" then
      [
        ./gaming.nix
        ./obs.nix
      ]
    else
      [ ]
  );

  home-manager.users.clamt.imports = [
    ./fuzzel.nix
    ./micro.nix
    ./yazi.nix

    ./bars/quickshell.nix
  ];
}
