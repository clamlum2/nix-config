{
  description = "My main NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    vicinae.url = "github:vicinaehq/vicinae";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    hyprlauncher.url = "github:hyprwm/hyprlauncher";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixos-wsl,
    home-manager,
    nixpkgs-unstable,
    lanzaboote,
    vicinae,
    spicetify-nix,
    hyprlauncher,
    ...
  }:
  {
    nixosConfigurations = {

      ##################
      # PC Configuration
      ##################

      nixos = let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };

        hyprOverlays = if builtins.hasAttr "overlays" hyprlauncher && builtins.hasAttr "default" hyprlauncher.overlays
          then [ hyprlauncher.overlays.default ]
          else [];

        hyprPkg = if builtins.hasAttr "packages" hyprlauncher && builtins.hasAttr system hyprlauncher.packages && builtins.hasAttr "default" (hyprlauncher.packages.${system})
          then hyprlauncher.packages.${system}.default
          else null;

        spicePkgs = spicetify-nix.legacyPackages.${system};
      in nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./configuration.nix
          ./modules/devices/pc.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              nixpkgs-unstable = nixpkgs-unstable;
            };
            home-manager.users.clamt = { pkgs, ... }: {
              imports = [
                inputs.vicinae.homeManagerModules.default
                ./home.nix
                ./modules/apps/vicinae.nix
              ];
            };
          }

          lanzaboote.nixosModules.lanzaboote

          ({ pkgs, lib, ... }: {

            environment.systemPackages = [
              pkgs.git
              pkgs.sbctl
            ] ++ lib.optional (hyprPkg != null) hyprPkg;

            boot.loader.systemd-boot.enable = lib.mkForce false;

            boot.lanzaboote = {
              enable = true;
              pkiBundle = "/var/lib/sbctl";
            };
          })

          spicetify-nix.nixosModules.default

          (import ./modules/apps/spicetify.nix { inherit spicePkgs; })

        ];
        specialArgs = {
          inherit nixpkgs-unstable;
        };
      };

      ######################
      # Laptop Configuration
      ######################

      laptop = let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };

        hyprOverlays = if builtins.hasAttr "overlays" hyprlauncher && builtins.hasAttr "default" hyprlauncher.overlays
          then [ hyprlauncher.overlays.default ]
          else [];

        hyprPkg = if builtins.hasAttr "packages" hyprlauncher && builtins.hasAttr system hyprlauncher.packages && builtins.hasAttr "default" (hyprlauncher.packages.${system})
          then hyprlauncher.packages.${system}.default
          else null;

        spicePkgs = spicetify-nix.legacyPackages.${system};
      in nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          ./modules/devices/laptop.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              nixpkgs-unstable = nixpkgs-unstable;
            };
            home-manager.users.clamt = { pkgs, ... }: {
              imports = [
                ./home.nix
              ];
            };
          }

          ({ pkgs, lib, ... }: {
            environment.systemPackages = [
              pkgs.git
            ] ++ lib.optional (hyprPkg != null) hyprPkg;
          })

          spicetify-nix.nixosModules.default

          (import ./modules/apps/spicetify.nix { inherit spicePkgs; })
        ];
        specialArgs = {
          inherit nixpkgs-unstable;
        };
      };

      ###################
      # WSL Configuration
      ###################

      wsl = let
        system = "aarch64-linux";
        pkgs = import nixpkgs { inherit system; };
      in nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./modules/devices/wsl.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              nixpkgs-unstable = nixpkgs-unstable;
            };
            home-manager.users.clamt = { pkgs, ... }: {
              imports = [
                ./modules/devices/wsl-home.nix
              ];
            };
          }

          ({ pkgs, lib, ... }: {
            environment.systemPackages = [
              pkgs.git
            ];
          })

          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "25.11";
            wsl.enable = true;
          }
        ];
        specialArgs = {
          inherit nixpkgs-unstable;
        };
      };
    };
  };
}