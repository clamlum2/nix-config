{ device, ... }:
{
  home-manager.users.clamt.imports = [
    ./wezterm.nix
  ]
  ++ (
    if device == "nixos" then
      [
        ./ghostty.nix
        ./kitty.nix
      ]
    else
      [ ]
  );
}
