{
  description = "personal cachyos kernel flake";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      cachyVersion = "7.0.8";
      cachyRelease = "1";
      modDirVersion = "7.0.8-cachyos";
      version = "${cachyVersion}-${cachyRelease}";
    in
    {
      packages.x86_64-linux.kernel =
        (pkgs.linuxManualConfig {
          inherit version modDirVersion;
          src = pkgs.fetchurl {
            url = "https://github.com/CachyOS/linux/releases/download/cachyos-${version}/cachyos-${version}.tar.gz";
            hash = "sha256-TEwhSelYxxDoWW7GeJsr4t/LFMGR94VRLHdT99ia3HU=";
          };
          configfile = ./kernel_config;
          allowImportFromDerivation = true;
        }).overrideAttrs
          (old: {
            passthru = (old.passthru or { }) // {
              features = (old.passthru.features or { }) // {
                ia32Emulation = true;
              };
            };
          });
    };
}
