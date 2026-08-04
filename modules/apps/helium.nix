{
  fetchurl,
  appimageTools,
  makeDesktopItem,
  makeWrapper,
}:

let
  pname = "helium-browser";
  version = "0.15.1.1";

  extraFlags = "--password-store=basic";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    sha256 = "sha256-qz3w+nnvBgkpHT3E34dv4DvFuYlyzTAyg9tPYJFWs3o=";
  };

  extracted = appimageTools.extract {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Helium";
    comment = "Web browser";
    exec = "${pname} ${extraFlags} %U";
    terminal = false;
    categories = [
      "Network"
      "WebBrowser"
    ];
    icon = pname;
    startupWMClass = "helium-browser";
  };
in

appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraPkgs =
    pkgs: with pkgs; [
      libva
      mesa
      libGL
      vulkan-loader
    ];

  extraEnv = {
    LIBVA_DRIVER_NAME = "radeonsi";
    LIBVA_DRIVERS_PATH = "/run/opengl-driver/lib/dri";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    NIXOS_OZONE_WL = "1";
  };

  extraInstallCommands = ''
    install -Dm444 ${desktopItem}/share/applications/${pname}.desktop \
      -t "$out/share/applications"

    wrapProgram $out/bin/${pname} \
      --add-flags "${extraFlags}"

    install -Dm444 ${extracted}/.DirIcon \
      $out/share/pixmaps/${pname}.png
  '';
}
