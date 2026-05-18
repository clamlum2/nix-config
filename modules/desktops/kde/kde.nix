{ pkgs, ... }:

{
  services.desktopManager.plasma6 = {
    enable = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    dolphin
    dolphin-plugins

    gwenview
    okular
    kate
    kwrited

    elisa
    dragon

    ark
    kalk
    kmail
    kontact
    korganizer
    kaddressbook
    kleopatra
    print-manager
    khelpcenter

    plasma-browser-integration

    konsole

    kpat

    discover
  ];

  security.pam.services.login.kwallet.enable = true;
}
