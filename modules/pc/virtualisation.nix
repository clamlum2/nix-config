{ config, pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;

  virtualisation.libvirtd.qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
  };

  programs.virt-manager.enable = true;

  networking.firewall.checkReversePath = false;

  users.users.clamt = {
    extraGroups = [ "libvirtd" "kvm" ];
  };

  services.spice-vdagentd.enable = true;
}
