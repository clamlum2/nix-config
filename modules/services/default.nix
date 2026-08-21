{ device, username, ... }:

{
  imports = [
    ./fonts.nix
  ]
  ++ (
    if device != "macbook" then
      [
        ./audio.nix
        ./gtk.nix
        ./qt.nix
        ./libinput.nix
      ]
    else
      [ ]
  );

  home-manager.users.${username}.imports =
    [ ]
    ++ (
      if device != "macbook" then
        [
          ./icons.nix
          ./mako.nix
        ]
      else
        [ ]
    );
}
