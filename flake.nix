{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kopuz.url = "github:temidaradev/kopuz";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nixos-lxc.url = "path:./lxc-config";

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      ...
    }@inputs:
    let
      mkSystem = nixpkgs.lib.nixosSystem;
      username = "clamt";
    in
    {
      nixosConfigurations = {
        nixos = mkSystem {
          system = "x86_64-linux";
          specialArgs = {
            device = "nixos";
            inherit username;
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
            inherit username;
            inherit (inputs) self;
            inherit inputs;
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
            inherit username;
            inherit (inputs) nixpkgs-stable self;
            inherit inputs;
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

      darwinConfigurations.macbook =
        let
          device = "macbook";
        in
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit device;
            inherit username;
            inherit (inputs) nixpkgs-stable self;
            inherit inputs;
          };
          modules = [
            ./modules
            ./modules/devices/macbook
            ./modules/apps
            ./modules/shell
            ./modules/desktops/services/fonts.nix
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  self = inputs.self;
                  inherit device;
                };
              };
            }
          ];
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
