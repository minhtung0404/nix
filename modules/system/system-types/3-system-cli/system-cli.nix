{ inputs, den, ... }: {
  # den side of this tier; the flake.modules below move into it step by step
  den.aspects.system-cli.includes = with den.aspects; [
    fish
    cliTools
    sops
    edns
  ];

  # import all essential nix-tools which are used in all modules of a specific class

  flake.modules.nixos.system-cli = {
    imports = with inputs.self.modules.nixos; [
      system-default
      homeManager
    ];
  };

  flake.modules.darwin.system-cli = {
    imports = with inputs.self.modules.darwin; [
      system-default
      homeManager
    ];
  };

  # impermanence is not added by default to home-manager, because of missing Darwin implementation
  # for linux home-manager stand-alone configurations it has to be added manualy

  flake.modules.homeManager.system-cli = {
    imports = with inputs.self.modules.homeManager; [
      system-default
    ];

    home.sessionVariables = {
      EDITOR = "kak";
    };

    home.shell.enableFishIntegration = true;
  };
}
