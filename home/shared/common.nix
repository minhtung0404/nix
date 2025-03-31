{ inputs, config, pkgs, lib, ... }:
let cfg = config.mtn.hm;
in {
  imports = [
    ../../modules/config.nix

    ../../modules/editors/nvim
    ../../modules/editors/kakoune
    ../../modules/misc/git
    ../../modules/misc/ssh
    ../../modules/shells/fish
    ../../modules/terminals/kitty
  ];

  options.mtn.hm = {
    enable = lib.mkEnableOption "hm";
    darwin = lib.mkEnableOption "hm-darwin";
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
      nixfmt-classic
      obsidian
      podman
      ripgrep
      stylua
      telegram-desktop
      lazygit
      nodejs_23
    ];

    home.sessionVariables = { EDITOR = "nvim"; };

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
      my-nvim.enable = true;
      my-kitty = {
        enable = true;
        fontSize = 16;
        cmd = "cmd";
      };
    };
  };
}
