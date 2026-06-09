{ device, ... }:
{
  imports = [
    # ./vesktop.nix
    ./vencord.nix
    ./zed.nix

    ./terminals
  ]
  ++ (
    if device == "nixos" then
      [
        ./kopuz.nix
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
