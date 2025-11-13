{
  description = "My main NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    vicinae.url = "github:vicinaehq/vicinae";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{self, nixpkgs, home-manager, nixpkgs-unstable, lanzaboote, vicinae, ...}: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          ./imports/pc.nix
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
              ];
            };
          }

          lanzaboote.nixosModules.lanzaboote

          ({ pkgs, lib, ... }: {

            environment.systemPackages = [
              pkgs.sbctl
            ];

            boot.loader.systemd-boot.enable = lib.mkForce false;

            boot.lanzaboote = {
              enable = true;
              pkiBundle = "/var/lib/sbctl";
            };
          })
        ];
        specialArgs = {
          inherit nixpkgs-unstable;
        };
      };
      laptop = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          ./imports/laptop.nix
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
        ];
        specialArgs = {
          inherit nixpkgs-unstable;
        };
      };
    };
  };
}