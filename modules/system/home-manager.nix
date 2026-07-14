{
  flake.modules.homeManager.default =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.mtn.hm;
    in
    {
      options = {
        mtn.hm = {
          enable = lib.mkEnableOption "hm";
          darwin = lib.mkEnableOption "hm-darwin";
        };
      };

      config = lib.mkIf cfg.enable {
        home.stateVersion = "26.05";
        programs.home-manager.enable = true;

        home.packages = with pkgs; [
          obsidian
          telegram-desktop
        ];

        home.sessionVariables = {
          EDITOR = "kak";
        };

        home.shell.enableFishIntegration = true;

        mtn.programs = {
          my-kitty = {
            fontSize = 16;
            cmd = "cmd";
          };

          my-kakoune.enable-fish-session = true;
        };

      };
    };
}
