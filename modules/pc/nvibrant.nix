{ nvibrant, ... }: {
  imports = [
    nvibrant.homeModules.default
  ];

  services.nvibrant = {
    enable = true;

    vibrancy = [
      "0%"
      "200%"
      "0%"
      "0%"
      "200%"
    ];
  };
}