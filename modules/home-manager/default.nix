{
  config,
  inputs,
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
    home.stateVersion = "24.11";
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      coreutils
      curl
      discord
      dust
      entr
      grc
      btop
      lazygit
      nerd-fonts.fira-code
      nixfmt-rfc-style
      obsidian
      podman
      ripgrep
      stylua
      telegram-desktop
      tldr

      mtn-kakoune
      gnumake
      unzip
      zip
      deluge
    ];

    home.sessionVariables = {
      EDITOR = "kak";
    };

    home.shell.enableFishIntegration = true;

    programs.bat = {
      enable = true;
      config = {
        theme = "GitHub";
      };
      extraPackages = with pkgs.bat-extras; [
        batgrep
      ];
    };

    programs.eza.enable = true;

    programs.fd.enable = true;

    programs.jq.enable = true;
    programs.jqp.enable = true;

    programs.man.enable = true;

    programs.vscode.enable = true;

    programs.nushell.enable = true;

    programs.zoxide = {
      enable = true;
      options = [ "--cmd j" ];
    };

    programs.fzf = {
      enable = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.load_dotenv = true;
    };

    services.tldr-update.enable = true;

    mtn.programs = {
      my-kitty = {
        enable = true;
        fontSize = 16;
        cmd = "cmd";
      };

      my-git.enable = true;
      my-ssh.enable = true;
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

      }
      {
        id = "6";
        name = "games";
        icon = "🎮";
      }
      {
        id = "7";
        name = "7";
        icon = "";
        monitor = "secondary";
      }
    ];
  };
}
