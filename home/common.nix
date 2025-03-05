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
    hidden-bar
    htop
    jq
    kanata-with-cmd
    neovim
    obsidian
    podman
    raycast
    ripgrep
    sketchybar-app-font
    stylua
    telegram-desktop
    thefuck
    vscode
    zoxide
    fishPlugins.grc
    fishPlugins.plugin-git
    grc
    nixfmt-classic
    nerd-fonts.fira-code
  ];

  imports = [ ../modules/shells/fish ../modules/misc/git ];

  programs.zoxide.enable = true;
  programs.zoxide.enableFishIntegration = true;
  programs.zoxide.options = [ "--cmd j" ];

  programs.eza.enable = true;

  programs.fd.enable = true;

}
