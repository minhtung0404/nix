{ config, pkgs, ... }:

{
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  programs.direnv.enable = true;

  home.packages = with pkgs; [
    aerospace
    aldente
    coreutils
    curl
    discord
    fishPlugins.grc
    fishPlugins.plugin-git
    grc
    hidden-bar
    htop
    kanata-with-cmd
    neovim
    nerd-fonts.fira-code
    nixfmt-classic
    obsidian
    podman
    raycast
    ripgrep
    sketchybar-app-font
    stylua
    telegram-desktop
  ];

  imports = [ ../modules/shells/fish ../modules/misc/git ];

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
}
