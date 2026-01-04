{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = inputs@ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nixos-wsl,
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
      in nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./hardware-configuration.nix

          ./modules/pc/pc.nix
          ./modules/pc/nvidia.nix

          ./modules/configuration.nix
          ./modules/pkgs.nix

          ./modules/greetd.nix

          ./modules/desktop/fonts.nix
          ./modules/apps/gaming.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                nixpkgs-stable = nixpkgs-stable;
                self = self;
              };
              users.clamt = { pkgs, ... }: {
                imports = [
                  ./modules/home.nix

                  ./modules/hyprland/hyprland.nix
                  ./modules/hyprland/pc-hyprland.nix
                  ./modules/hyprland/hyprpaper.nix

                  ./modules/desktop/icons.nix
                  ./modules/desktop/mako.nix

                  ./modules/shell/zsh.nix
                  ./modules/shell/themes/blue.nix

                  ./modules/bars/quickshell.nix

                  ./modules/terminals/ghostty.nix

                  ./modules/apps/fuzzel.nix
                ];
              };
            };
          }
        ];
        specialArgs = {
          inherit nixpkgs-stable;
          inherit self;
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
          ./modules/wsl/wsl.nix

          ./modules/desktop/fonts.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                nixpkgs-stable = nixpkgs-stable;
                self = self;
              };
              users.clamt = { pkgs, ... }: {
                imports = [
                  ./modules/wsl/wsl-home.nix

                  ./modules/shell/zsh.nix
                  ./modules/shell/themes/blue.nix
                ];
              };
            };
          }
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "25.11";
            wsl.enable = true;
          }
        ];
        specialArgs = {
          inherit nixpkgs-stable;
          inherit self;
        };
      };
    };
  };
}
