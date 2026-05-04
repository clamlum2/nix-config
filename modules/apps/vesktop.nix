{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.vesktop
    (pkgs.lib.hiPrio (
      pkgs.writeShellScriptBin "vesktop" ''
        export LIBVA_DRIVER_NAME=radeonsi
        export LIBVA_DRIVERS_PATH=/run/opengl-driver/lib/dri
        export VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json
        export LD_LIBRARY_PATH=/run/opengl-driver/lib:${pkgs.libva.out}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
        exec ${pkgs.vesktop}/bin/vesktop "$@"
      ''
    ))
  ];
}
