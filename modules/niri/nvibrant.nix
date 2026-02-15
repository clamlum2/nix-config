{ nvibrant, ... }: {
  imports = [
    nvibrant.homeModules.default
  ];

  services.nvibrant = {
    enable = true;

    arguments = [
      "0"
      "1023"
      "0"
      "0"
      "1023"
    ];
  };
}