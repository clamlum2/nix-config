{ device, username, ... }:
{
  home-manager.users.${username}.imports =
    if device == "macbook" then
      [ ./ghostty.nix ]
    else if device == "nixos" then
      [
        ./ghostty.nix
        ./kitty.nix
        ./wezterm.nix
      ]
    else
      [ ./wezterm.nix ];
}
