{
  inputs,
  ...
}:
{
  # expansion of cli system for desktop use

  flake.modules.nixos.system-desktop = {
    imports = with inputs.self.modules.nixos; [
      system-cli

      kanata
      battery
    ];
  };

  flake.modules.darwin.system-desktop = {
    imports = with inputs.self.modules.darwin; [
      system-cli
    ];
  };

  flake.modules.homeManager.system-desktop = { pkgs, ... }: {
    imports = with inputs.self.modules.homeManager; [
      system-cli

      zenBrowser
      kakoune
      vesktop
      kitty
      scrollingDesktop
      waybar
      graphical
    ];

    home.packages = with pkgs; [
      obsidian
      telegram-desktop
    ];

    mtn.programs = {
      my-kitty = {
        fontSize = 16;
        cmd = "cmd";
      };

      my-kakoune.enable-fish-session = true;
    };

  };
}
