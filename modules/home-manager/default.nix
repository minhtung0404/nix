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
      inputs.nvf.homeManagerModules.default
      ./config.nix
      ./darwin
      ./editors/kakoune
      ./gui/aerospace
      ./gui/sketchybar
      ./terminals/kitty
    ]
    ++ (myLib.extendModules (extends "programs") [
      ./editors/nvf.nix
      ./programs/git.nix
      ./programs/ssh.nix
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
      dust
      entr
      fishPlugins.grc
      fishPlugins.plugin-git
      grc
      htop
      lazygit
      librewolf
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
