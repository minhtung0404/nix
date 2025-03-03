{ pkgs, ...}:

{
  users.users.minhtung0404 = {
    home = "/Users/minhtung0404/";
  };

  users.users.entertainment = {
    home = "/Users/entertainment/";
  };
 
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
 
  homebrew = {
    enable = true;
 
    casks = [
      "librewolf"
    ];
  };

  services.sketchybar.enable = true;
  services.sketchybar.extraPackages = [
    pkgs.lua5_4_compat
    pkgs.aerospace
    pkgs.nowplaying-cli
  ];

  launchd.user.agents.sketchybar.serviceConfig = {
    StandardOutPath = "/tmp/sbar.log";
    StandardErrorPath = "/tmp/sbar_err.log";
  };

  system.stateVersion = 6;
}
