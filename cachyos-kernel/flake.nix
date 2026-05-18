{
  description = "personal cachyos kernel flake";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      cachyVersion = "7.1-rc4";
      cachyRelease = "1";
      modDirVersion = "7.1.0-rc4-cachyos";
      version = "${cachyVersion}-${cachyRelease}";
    in
    {
      packages.x86_64-linux.kernel =
        (pkgs.linuxManualConfig {
          inherit version modDirVersion;
          src = pkgs.fetchurl {
            url = "https://github.com/CachyOS/linux/releases/download/cachyos-${version}/cachyos-${version}.tar.gz";
            hash = "sha256-4bKV0R/O9I6Tq0YDyXRehuIC+NAUV32OPzm4/YPm/4g=";
          };
          configfile = ./kernel_config;
          allowImportFromDerivation = true;
        }).overrideAttrs
          (old: {
            passthru = (old.passthru or { }) // {
              features = (old.passthru.features or { }) // {
                ia32Emulation = true;
                efiBootStub = true;
              };
            };
          });
    };
}
