{ spicePkgs, ... }:
{
  programs.spicetify = {
    enable = true;

    theme = spicePkgs.themes.default;

    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      fullScreen
      beautifulLyrics
    ];

    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
    ];
  };
}