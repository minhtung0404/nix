{ pkgs, config, ... }:

{
  users.users.minhtung0404 = {
    name = "minhtung0404";
    home = "/Users/minhtung0404/";
    shell =
      "${config.home-manager.users.minhtung0404.programs.fish.package}/bin/fish";
  };

  users.users.entertainment = {
    name = "entertainment";
    home = "/Users/entertainment/";
    shell =
      "${config.home-manager.users.entertainment.programs.fish.package}/bin/fish";
  };

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  homebrew = {
    enable = true;

    casks = [ "librewolf" ];
  };

  imports = [
    ../modules/gui/aerospace
    # ../modules/gui/sketchybar
    ../modules/keyboards/kanata/darwin.nix
  ];

  system.stateVersion = 6;
}
