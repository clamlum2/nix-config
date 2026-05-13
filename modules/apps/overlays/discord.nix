let
  version = "1.0.138";
in

final: prev: {
  discord =
    (prev.discord.override {
      binaryName = "discord";
      commandLineArgs = "--enable-gpu-rasterization --enable-zero-copy --ignore-gpu-blocklist";
    }).overrideAttrs
      (old: {
        version = version;

        src = prev.fetchurl {
          url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
          sha256 = "sha256-PFwhTekHL6zwn8grAxhFrsAVunJ6EFgfeatpWm3/Eck=";
        };

        postFixup = (old.postFixup or "") + ''
          wrapProgram "$out/bin/discord" \
            --set LIBVA_DRIVER_NAME radeonsi \
            --set LIBVA_DRIVERS_PATH /run/opengl-driver/lib/dri \
            --set VK_ICD_FILENAMES /run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json \
            --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:${prev.libva.out}/lib
        '';
      });
}
