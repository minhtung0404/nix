{ pkgs, ... }:

{
  users.users.minhtung0404 = { home = "/Users/minhtung0404/"; };

  users.users.entertainment = { home = "/Users/entertainment/"; };

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  homebrew = {
    enable = true;

    casks = [ "librewolf" ];
  };

  imports = [ ../modules/gui/aerospace ../modules/gui/sketchybar ];

  system.stateVersion = 6;
}
