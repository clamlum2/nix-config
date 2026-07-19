{ pkgs, ... }:

{
  users.users.clamt.extraGroups = [
    "adbusers"
    "kvm"
  ];

  environment.systemPackages = with pkgs; [
    android-studio

    android-tools
    jdk17
  ];

  virtualisation.libvirtd.enable = true;

  boot.kernelModules = [
    "kvm-amd"
  ];
}
