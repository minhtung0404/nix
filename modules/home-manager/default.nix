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
  imports = [
    ./config.nix
    ./shared
  ];
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
        enable = true;
        fontSize = 16;
        cmd = "cmd";
      };

      my-git.enable = true;
      my-ssh.enable = true;
      my-discord.enable = true;
      my-fish = {
        enable = true;
        tide.enable = true;
      };

      my-kakoune.enable-fish-session = true;
    };

    mtn.workspaces = [
      {
        id = "1";
        name = "web";
        icon = "🌐";
      }
      {
        id = "2";
        name = "work";
        icon = "💻";
      }
      {
        id = "3";
        name = "notes";
        icon = "📝";

      }
      {
        id = "4";
        name = "mail";
        icon = "📩";

      }
      {
        id = "5";
        name = "chat";
        icon = "💬";
        monitor = "secondary";

      }
      {
        id = "6";
        name = "games";
        icon = "🎮";
      }
      {
        id = "7";
        name = "other";
        icon = "🔣";
        monitor = "secondary";
      }
    ];
  };
}
