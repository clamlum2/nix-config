let
  version = "1.0.142";
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

      base = prev.stdenv.mkDerivation {
        pname = "discord";
        inherit version;

        src = prev.fetchurl {
          url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
          sha256 = "sha256-BKM7YHophzeWkkRKxe1TR3jr9CrcmnLv+/9aWGgJCOE=";
        };

        nativeBuildInputs = [
          prev.autoPatchelfHook
          prev.makeShellWrapper
        ];
        buildInputs = libs;

        dontConfigure = true;
        dontBuild = true;
        dontUnpack = true;

        installPhase =
          let
            binaryName = "discord";
          in
          ''
            runHook preInstall
            mkdir -p $out/opt/${binaryName} $out/bin \
                     $out/share/applications \
                     $out/share/icons/hicolor/256x256/apps

            tar xzf $src --strip-components=1 -C $out/opt/${binaryName}
            chmod +x $out/opt/${binaryName}/${binaryName}

            ln -s $out/opt/${binaryName}/${binaryName} $out/bin/${binaryName}

            ln -s $out/opt/${binaryName}/updater_bootstrap $out/bin/updater_bootstrap

            ln -s $out/opt/${binaryName}/${binaryName}.png \
                  $out/share/icons/hicolor/256x256/apps/${binaryName}.png

            runHook postInstall
          '';
      };

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

        rm -f $out/share/applications/discord.desktop
        cat > $out/share/applications/discord.desktop << EOF
        [Desktop Entry]
        Name=Discord
        Comment=All-in-one voice and text chat
        Exec=${fhs}/bin/discord %U
        Icon=discord
        Terminal=false
        Type=Application
        Categories=Network;InstantMessaging;
        MimeType=x-scheme-handler/discord;
        StartupWMClass=discord
        EOF
      '';
    };
}
