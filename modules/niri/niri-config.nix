{ config, ... }:

{
  home.file.".config/niri/config.kdl".source = ../../resources/niri/niri.kdl;
}