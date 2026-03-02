{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixos-lxc.url = "path:./lxc-config";

    nvibrant = {
      url = "github:mikaeladev/nix-nvibrant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nixos-wsl,
    nix-cachyos-kernel,
    nixos-lxc,
    nvibrant,
    ...
  }:
  {
    nixosConfigurations = {

      ##################
      # PC Configuration
      ##################

      nixos = let
        system = "x86_64-linux";
      in nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ({ ... }: {
            nixpkgs.overlays = [
              nvibrant.overlays.default
              nix-cachyos-kernel.overlays.pinned
            ];
          })
          ./modules/pc/hardware-configuration.nix

          ./modules/pc/pc.nix
          ./modules/pc/amd.nix
          ./modules/pc/virtualisation.nix

          ./modules/configuration.nix
          ./modules/pkgs.nix

          ./modules/niri/niri.nix

					# ./modules/kde/kde.nix

          ./modules/dm/greetd.nix
          # ./modules/dm/ly.nix

          ./modules/desktop/fonts.nix
          ./modules/desktop/audio.nix
          ./modules/desktop/gtk.nix

          ./modules/apps/gaming.nix
          ./modules/apps/obs.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                nixpkgs-stable = nixpkgs-stable;
                self = self;
                nvibrant = nvibrant;
              };
              users.clamt = { pkgs, ... }: {
                imports = [
                  ./modules/home.nix

                  ./modules/niri/niri-config.nix

                  ./modules/pc/nvibrant.nix

                  ./modules/desktop/icons.nix
                  ./modules/desktop/mako.nix

                  ./modules/shell/zsh.nix
                  ./modules/shell/themes/blue.nix

                  ./modules/bars/quickshell.nix

                  ./modules/terminals/ghostty.nix
                  ./modules/terminals/wezterm.nix
                  ./modules/terminals/kitty.nix

                  ./modules/apps/fuzzel.nix
                  ./modules/apps/yazi.nix
                  ./modules/apps/micro.nix
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

      ######################
      # Laptop Configuration
      ######################

      laptop = let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
      in nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./modules/laptop/hardware-configuration.nix

          ./modules/laptop/laptop.nix

          ./modules/configuration.nix
          ./modules/pkgs.nix

          ./modules/niri/niri.nix

          ./modules/dm/greetd.nix

          ./modules/desktop/fonts.nix
          ./modules/desktop/audio.nix
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

                  ./modules/niri/niri-config.nix

                  ./modules/desktop/icons.nix
                  ./modules/desktop/mako.nix

                  ./modules/shell/zsh.nix
                  ./modules/shell/themes/blue.nix

                  ./modules/bars/quickshell.nix

                  ./modules/terminals/ghostty.nix
                  ./modules/terminals/wezterm.nix
                  ./modules/terminals/kitty.nix

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


    } // {
      lxc = nixos-lxc.nixosConfigurations.lxc;
      pterodactyl = nixos-lxc.nixosConfigurations.pterodactyl;
      mediaserver = nixos-lxc.nixosConfigurations.mediaserver;
    };
  };
}
