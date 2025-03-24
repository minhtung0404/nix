{ config, pkgs, lib, ... }: {
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
    neovim
    nerd-fonts.fira-code
    nixfmt-classic
    obsidian
    podman
    ripgrep
    stylua
    telegram-desktop
    lazygit
  ];

  imports = [
    ../../modules/shells/fish
    ../../modules/misc/git
    ../../modules/terminals/kitty
    ../../modules/editors/nvim
    ../../modules/misc/ssh
    ../../modules/config.nix
  ];

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
}
