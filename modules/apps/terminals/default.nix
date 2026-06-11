{ device, username, ... }:
{
  home-manager.users.${username}.imports = [
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
