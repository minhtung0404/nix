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
    eza
    fd
    hidden-bar
    htop
    jq
    kanata-with-cmd
    kitty
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
  ];

  imports = [ ../modules/shells/fish ];

  programs.zoxide.enable = true;
  programs.zoxide.enableFishIntegration = true;
  programs.zoxide.options = [ "--cmd j" ];

}
