{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nixos-lxc.url = "path:./lxc-config";
    cachyos-kernel.url = "./cachyos-kernel";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      nix-cachyos-kernel,
      lanzaboote,
      nixos-wsl,
      nixos-lxc,
      cachyos-kernel,
      ...
    }:
    {
      nixosConfigurations = {

        ##################
        # PC Configuration
        ##################

        nixos =
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            system = system;
            modules = [
              (
                { ... }:
                {
                  nixpkgs.overlays = [
                    nix-cachyos-kernel.overlays.pinned
                  ];
                }
              )
              ./modules/devices/pc/hardware-configuration.nix

              ./modules/devices/pc/pc.nix
              ./modules/devices/pc/amd.nix
              ./modules/devices/pc/virtualisation.nix

              ./modules/configuration.nix
              ./modules/pkgs.nix

              ./modules/desktops/niri/niri.nix

              ./modules/desktops/dm/greetd.nix

              ./modules/desktops/services/fonts.nix
              ./modules/desktops/services/audio.nix
              ./modules/desktops/services/gtk.nix

              ./modules/apps/gaming.nix
              ./modules/apps/obs.nix
              ./modules/apps/vesktop.nix
              ./modules/apps/zed.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  extraSpecialArgs = {
                    nixpkgs-stable = nixpkgs-stable;
                    self = self;
                    repoRoot = ./.;
                  };
                  users.clamt =
                    { ... }:
                    {
                      imports = [
                        ./modules/home.nix

                        ./modules/desktops/niri/niri-config.nix

                        ./modules/desktops/services/icons.nix
                        ./modules/desktops/services/mako.nix

                        ./modules/shell/zsh.nix
                        ./modules/shell/themes/blue.nix

                        ./modules/apps/bars/quickshell.nix

                        ./modules/apps/terminals/ghostty.nix
                        ./modules/apps/terminals/wezterm.nix
                        ./modules/apps/terminals/kitty.nix

                        ./modules/apps/fuzzel.nix
                        ./modules/apps/yazi.nix
                        ./modules/apps/micro.nix
                      ];
                    };
                };
              }
              lanzaboote.nixosModules.lanzaboote
              (
                { pkgs, lib, ... }:
                {

                  environment.systemPackages = [
                    pkgs.sbctl
                  ];

                  boot.loader.systemd-boot.enable = lib.mkForce false;

                  boot.lanzaboote = {
                    enable = true;
                    pkiBundle = "/var/lib/sbctl";
                  };
                }
              )
            ];
            specialArgs = {
              inherit nixpkgs-stable cachyos-kernel;
              inherit self;
            };
          };

        ######################
        # Laptop Configuration
        ######################

        laptop =
          let
            system = "x86_64-linux";
          in
          nixpkgs.lib.nixosSystem {
            system = system;
            modules = [
              ./modules/devices/laptop/hardware-configuration.nix

              ./modules/devices/laptop/laptop.nix

              ./modules/configuration.nix
              ./modules/pkgs.nix

              ./modules/desktops/niri/niri.nix

              ./modules/desktops/greetd.nix

              ./modules/desktops/services/fonts.nix
              ./modules/desktops/services/audio.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  extraSpecialArgs = {
                    nixpkgs-stable = nixpkgs-stable;
                    self = self;
                    repoRoot = ./.;
                  };
                  users.clamt = {
                    imports = [
                      ./modules/home.nix

                      ./modules/desktops/niri/niri-config.nix

                      ./modules/desktops/services/icons.nix
                      ./modules/desktops/services/mako.nix

                      ./modules/shell/zsh.nix
                      ./modules/shell/themes/blue.nix

                      ./modules/apps/bars/quickshell.nix

                      ./modules/apps/terminals/ghostty.nix
                      ./modules/apps/terminals/wezterm.nix
                      ./modules/apps/terminals/kitty.nix

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

        wsl =
          let
            system = "aarch64-linux";
          in
          nixpkgs.lib.nixosSystem {
            system = system;
            modules = [
              ./modules/devices/wsl/wsl.nix

              ./modules/desktops/services/fonts.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  extraSpecialArgs = {
                    nixpkgs-stable = nixpkgs-stable;
                    self = self;
                    repoRoot = ./.;
                  };
                  users.clamt = {
                    imports = [
                      ./modules/devices/wsl/wsl-home.nix

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

      }
      // {
        lxc = nixos-lxc.nixosConfigurations.lxc;
        pterodactyl = nixos-lxc.nixosConfigurations.pterodactyl;
        mediaserver = nixos-lxc.nixosConfigurations.mediaserver;
        vaultwarden = nixos-lxc.nixosConfigurations.vaultwarden;
      };
    };
}
