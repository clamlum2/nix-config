{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    ...
  }:
  {
    nixosConfigurations = {

      # Testing LXC configuration

      lxc = let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/configuration.nix
          ./modules/pkgs.nix

          ./modules/docker.nix
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
              users.root = { pkgs, ... }: {
                imports = [
                  ./modules/home.nix

                  ../modules/shell/zsh.nix
                  ../modules/shell/themes/green.nix
                  ../modules/apps/micro.nix
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

      # Pterodactyl LXC configuration

      pterodactyl = let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/configuration.nix
          ./modules/pkgs.nix

          ./modules/docker.nix
          ./modules/pterodactyl/pterodactyl.nix
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
              users.root = { pkgs, ... }: {
                imports = [
                  ./modules/home.nix

                  ../modules/shell/zsh.nix
                  ../modules/shell/themes/green.nix
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

      # Media Server LXC configuration

      mediaserver = let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/configuration.nix
          ./modules/pkgs.nix

          ./modules/docker.nix
          ./modules/mediaserver/mediaserver.nix
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
              users.root = { pkgs, ... }: {
                imports = [
                  ./modules/home.nix

                  ../modules/shell/zsh.nix
                  ../modules/shell/themes/yellow.nix
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

      # Vaultwarden LXC configuration

      vaultwarden = let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/configuration.nix
          ./modules/pkgs.nix

          ./modules/docker.nix
          ./modules/vaultwarden/vaultwarden.nix
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
              users.root = { pkgs, ... }: {
                imports = [
                  ./modules/home.nix

                  ../modules/shell/zsh.nix
                  ../modules/shell/themes/purple.nix
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
    };
  };
}
