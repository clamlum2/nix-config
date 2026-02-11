{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nixos-lxc.url = "path:./lxc-config";
  };

  outputs = inputs@ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nixos-wsl,
    nix-cachyos-kernel,
    nixos-lxc,
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
          ./modules/pc/hardware-configuration.nix

          ./modules/pc/pc.nix
          ./modules/pc/nvidia.nix
          ./modules/pc/virtualisation.nix

          ./modules/configuration.nix
          ./modules/pkgs.nix

          ./modules/greetd.nix

          ./modules/desktop/fonts.nix
          ./modules/desktop/audio.nix

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
              };
              users.clamt = { pkgs, ... }: {
                imports = [
                  ./modules/home.nix

                  ./modules/hyprland/hyprland.nix
                  ./modules/hyprland/hyprpaper.nix
                  ./modules/hyprland/hyprlock.nix
                  ./modules/hyprland/plugins.nix

                  ./modules/pc/hyprland-monitors.nix

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
          ({ pkgs, ... }: { nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ]; })
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

          ./modules/greetd.nix

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

                  ./modules/hyprland/hyprland.nix
                  ./modules/hyprland/hyprpaper.nix
                  ./modules/hyprland/hyprlock.nix

                  ./modules/laptop/hyprland-monitors.nix

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
