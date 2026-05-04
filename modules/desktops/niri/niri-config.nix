{ repoRoot, ... }:

{
  home.file.".config/niri/config.kdl".source = "${repoRoot}/resources/niri/niri.kdl";
}
