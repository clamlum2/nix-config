{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kopuz.url = "github:temidaradev/kopuz";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nixos-lxc.url = "path:./lxc-config";
    cachyos-kernel.url = "./cachyos-kernel";

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      mkSystem = nixpkgs.lib.nixosSystem;
    in
    {
      nixosConfigurations = {
        nixos = mkSystem {
          system = "x86_64-linux";
          specialArgs = {
            device = "nixos";
            inherit (inputs) nixpkgs-stable self;
            inherit inputs;
          };
          modules = [
            ./modules
            ./modules/devices/pc
            ./modules/apps
            ./modules/shell
            ./modules/desktops/niri
            ./modules/desktops/kde
            ./modules/desktops/services
            ./modules/desktops/dm
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
                extraSpecialArgs = {
                  self = inputs.self;
                };
              };
            }
          ];
        };

        wsl = mkSystem {
          system = "aarch64-linux";
          specialArgs = {
            device = "wsl";
            inherit (inputs) self;
          };
          modules = [
            ./modules

            ./modules/devices/wsl

            ./modules/shell
            ./modules/desktops/services
            inputs.nixos-wsl.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
          ];
        };

        laptop = mkSystem {
          system = "x86_64-linux";
          specialArgs = {
            device = "laptop";
            inherit (inputs) self;
          };
          modules = [
            ./modules
            ./modules/devices/laptop
            ./modules/apps
            ./modules/shell
            ./modules/desktops/niri
            ./modules/desktops/services
            ./modules/desktops/dm
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                self = inputs.self;
              };
            }
          ];
        };
      };
    };

  nixConfig = {
    experimentalFeatures = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
  };
}
