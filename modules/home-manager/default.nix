{
  inputs,
  config,
  pkgs,
  lib,
  myLib,
  ...
}:
let
  cfg = config.mtn.hm;
  extends = type: name: {
    extraOptions = {
      mtn.${type}."my-${name}".enable = lib.mkEnableOption "enable my ${name} configuration";
    };

    configExtension = conf: (lib.mkIf config.mtn.${type}."my-${name}".enable conf);
  };
in
{
  imports =
    [
      ./config.nix
      ./darwin.nix
      ./editors/kakoune
      ./gui/aerospace
      ./gui/sketchybar
      ./terminals/kitty
    ]
    ++ (myLib.extendModules (extends "programs") [
      ./programs/git.nix
      ./programs/ssh.nix
      ./editors/nvim
      ./shells/fish
    ])
    ++ (myLib.extendModules (extends "services") [ ./services/hammerspoon ])
    ++ (myLib.extendModules (extends "bundles") (myLib.filesIn ./editors/kakoune/bundles));

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
      fishPlugins.grc
      fishPlugins.plugin-git
      # fishPlugins.fzf-fish
      grc
      htop
      nerd-fonts.fira-code
      nixfmt-rfc-style
      obsidian
      podman
      ripgrep
      stylua
      telegram-desktop
      lazygit
      bat
      bat-extras.batgrep
      bat-extras.batman
    ];

    home.sessionVariables = {
      EDITOR = "kak";
    };

    home.shell.enableFishIntegration = true;

    programs.eza.enable = true;

    programs.fd.enable = true;

    programs.jq.enable = true;
    programs.jqp.enable = true;

    programs.man.enable = true;

    programs.thefuck = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.vscode.enable = true;

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd j" ];
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.load_dotenv = true;
    };

    mtn.programs = {
      my-kitty = {
        enable = true;
        fontSize = 16;
        cmd = "cmd";
      };

      my-git.enable = true;
      my-ssh.enable = true;
      my-nvim.enable = true;
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
    };

  };
}
