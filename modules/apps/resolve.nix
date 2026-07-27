{
  pkgs,
  lib,
  ...
}:
let
  resolveEnv = {
    ROC_ENABLE_PRE_VEGA = "1";
    RUSTICL_ENABLE = "amdgpu,amdgpu-pro,radv,radeon,radeonsi";
    DRI_PRIME = "1";
    QT_QPA_PLATFORM = "xcb";
  };

  davinci-resolve-wrapped = pkgs.symlinkJoin {
    name = "davinci-resolve-wrapped";
    paths = [ pkgs.davinci-resolve ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/davinci-resolve \
        ${lib.concatStringsSep " " (
          lib.mapAttrsToList (name: value: "--set ${name} '${value}'") resolveEnv
        )}

      rm -f $out/share/applications/*.desktop
      for f in ${pkgs.davinci-resolve}/share/applications/*.desktop; do
        substitute "$f" "$out/share/applications/$(basename "$f")" \
          --replace "${pkgs.davinci-resolve}/bin/davinci-resolve" "$out/bin/davinci-resolve"
      done
    '';
  };
in
{
  environment.systemPackages = [
    davinci-resolve-wrapped
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa.opencl
    ];
  };
}
