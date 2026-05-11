{ pkgs, lib, ... }:

{

  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /run/libvirt/nix-ovmf - - - - ${pkgs.qemu}/share/qemu"
  ];

  programs.virt-manager.enable = true;

  networking.firewall.checkReversePath = false;

  users.users.clamt = {
    extraGroups = [
      "libvirtd"
      "kvm"
    ];
  };

  services.spice-vdagentd.enable = true;

  systemd.services.libvirtd.serviceConfig = {
    LoadCredentialEncrypted = lib.mkForce "";
    Environment = lib.mkForce [ ];
  };

  systemd.services.libvirtd.requires = lib.mkForce [ "virtlogd.socket" ];
  systemd.services.libvirtd.after = lib.mkForce [
    "libvirtd.socket"
    "libvirtd-ro.socket"
    "libvirtd-admin.socket"
    "virtlogd.socket"
    "virtlockd.socket"
    "network.target"
    "libvirtd-config.service"
  ];

  # virtualisation.docker ={
  #   enable = true;
  # };
}
