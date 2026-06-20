{
  description = "Zed Launcher";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    crane.url = "github:ipetkov/crane";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      crane,
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        isDarwin = pkgs.stdenv.isDarwin;

        craneLib = crane.mkLib pkgs;

        linuxRuntimeLibs = with pkgs; [
          libGL
          libxkbcommon
          wayland
          wayland-protocols
          mesa
          libglvnd

          libX11
          libXcursor
          libXrandr
          libXi
        ];

        src = craneLib.cleanCargoSource ./.;

        commonArgs = {
          inherit src;
          strictDeps = true;
          buildInputs = pkgs.lib.optionals (!isDarwin) linuxRuntimeLibs;
        };

        cargoArtifacts = craneLib.buildDepsOnly commonArgs;

        zedLauncher = craneLib.buildPackage (
          commonArgs
          // {
            inherit cargoArtifacts;

            nativeBuildInputs = pkgs.lib.optionals (!isDarwin) [ pkgs.makeWrapper ];

            postFixup = pkgs.lib.optionalString (!isDarwin) ''
              wrapProgram $out/bin/zed-launcher \
                --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath linuxRuntimeLibs}
            '';

            meta.mainProgram = "zed-launcher";
          }
        );
      in
      {
        packages.default = zedLauncher;

        devShells.default = craneLib.devShell {
          inputsFrom = [ zedLauncher ];
          buildInputs = pkgs.lib.optionals (!isDarwin) linuxRuntimeLibs;
        };
      }
    );
}
