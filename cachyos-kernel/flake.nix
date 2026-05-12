{
  description = "personal cachyos kernel flake";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      lib = nixpkgs.lib;
      cachyVersion = "7.1-rc3";
      cachyRelease = "1";
      modDirVersion = "7.1.0-rc3-cachyos";
      version = "${cachyVersion}-${cachyRelease}";
      branch = lib.head (lib.splitString "-" cachyVersion);
    in
    {
      packages.x86_64-linux.kernel = (pkgs.linuxManualConfig {
        inherit version modDirVersion;
        src = pkgs.fetchurl {
          url = "https://github.com/CachyOS/linux/releases/download/cachyos-${version}/cachyos-${version}.tar.gz";
          hash = "sha256-MYhV5ujJDHsBMNpKhNkQt+7YwbQxw7cu/tFtyarxbTM=";
        };
        configfile = ./config;
        allowImportFromDerivation = true;
      }).overrideAttrs (old: {
        passthru = (old.passthru or {}) // {
          features = (old.passthru.features or {}) // {
            ia32Emulation = true;
          };
        };
      });
    };
}
