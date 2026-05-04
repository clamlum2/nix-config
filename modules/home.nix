{ ... }:

{
  home.username = "clamt";
  home.homeDirectory = "/home/clamt";
  home.stateVersion = "25.11";

  home.file.".config/nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  home.file.".config/nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
    }
  '';
}
