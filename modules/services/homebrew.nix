{
  flake.modules.darwin.homebrew = { inputs, ... }: {
    imports = [
      inputs.nix-homebrew.darwinModules.nix-homebrew
      {
        nix-homebrew = {
          enable = true;
          enableRosetta = true;
          autoMigrate = true;
        };
        nix-homebrew.user = "minhtung0404";
      }
    ];

    homebrew = {
      enable = true;

      brews = [ "mas" ];

      casks = [
        "scroll-reverser"
        "hammerspoon"
      ];

      masApps = {
        "Bitwarden" = 1352778147;
      };

      onActivation.cleanup = "zap";
    };
  };
}
