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
    ./darwin
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

    programs.librewolf = {
      enable = true;
      settings = {
        "browser.tabs.groups.enabled" = true;
        "identity.fxaccounts.enabled" = true;
        "privacy.clearOnShutdown.downloads" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.resistFingerprinting" = false;
      };
    };

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

      my-kakoune = {
        enable = true;
        package = pkgs.nki-kakoune;
        enable-fish-session = true;
        bundles = "full";
      };
      my-nvf.enable = true;
    };
  };
}
