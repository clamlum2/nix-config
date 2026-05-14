let
  version = "1.0.138";
in
final: prev: {
  discord =
    let
      libs = with prev; [
        nspr
        nss
        nssTools
        alsa-lib
        libpulseaudio
        pipewire
        libGL
        libGLU
        mesa
        libva
        libva-utils
        libvdpau
        vulkan-loader
        libX11
        libXcomposite
        libXcursor
        libXdamage
        libXext
        libXfixes
        libXi
        libXrandr
        libXrender
        libXScrnSaver
        libXtst
        libxcb
        libxshmfence
        libXxf86vm
        wayland
        libxkbcommon
        glib
        gtk3
        gdk-pixbuf
        atk
        at-spi2-core
        at-spi2-atk
        pango
        cairo
        harfbuzz
        dbus
        expat
        fontconfig
        freetype
        zlib
        curl
        cups
        libdrm
        udev
        stdenv.cc.cc.lib
        libsecret
        libuuid
        krb5
        libgbm
      ];

      base =
        (prev.discord.override {
          binaryName = "discord";
          disableUpdates = false;
          commandLineArgs = "--enable-gpu-rasterization --enable-zero-copy --ignore-gpu-blocklist";
        }).overrideAttrs
          (old: {
            version = version;
            src = prev.fetchurl {
              url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
              sha256 = "sha256-PFwhTekHL6zwn8grAxhFrsAVunJ6EFgfeatpWm3/Eck=";
            };
          });

      fhs = prev.buildFHSEnv {
        name = "discord";
        targetPkgs = pkgs: libs;

        runScript = prev.writeShellScript "discord-run" ''
          export LIBVA_DRIVER_NAME=radeonsi
          export LIBVA_DRIVERS_PATH=/run/opengl-driver/lib/dri
          export VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json
          export LD_LIBRARY_PATH=${prev.lib.makeLibraryPath libs}:/run/opengl-driver/lib:${prev.libva.out}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
          exec ${base}/bin/discord "$@"
        '';
      };
    in
    prev.symlinkJoin {
      name = "discord";
      paths = [
        fhs
        base
      ];
      postBuild = ''
        rm -f $out/bin/discord
        ln -s ${fhs}/bin/discord $out/bin/discord
      '';
    };
}
