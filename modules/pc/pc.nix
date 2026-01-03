{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/44B26CAFB26CA760";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=1000" "umask=0022" ];
  };
}
