{ pkgs, lib, ... }:
let
  hmLaunchdList = [
    "sketchybar"
    "aerospace"
  ];
  loadBodyHmFn =
    load:
    pkgs.lib.concatMapStrings (name: ''
      case ${name}
        launchctl ${load} ~/Library/LaunchAgents/org.nix-community.home.${name}.plist
    '') hmLaunchdList;
  helperHm = pkgs.lib.concatMapStrings (name: "| ${name} ") hmLaunchdList;
  loadBody = load: ''
    switch $argv
      case "kanata"
        sudo launchctl ${load} /Library/LaunchDaemons/com.nixos.kanata.plist
      ${loadBodyHmFn load}
      case "*"
        echo "Usages: lctl-${load} [ kanata ${helperHm}]"
    end
  '';
in
{
  programs.fish.functions = lib.mkIf pkgs.stdenv.isDarwin {
    lctl-load = {
      body = loadBody "load";
      wraps = "launchctl";
    };

    lctl-unload = {
      body = loadBody "unload";
      wraps = "launchctl";
    };
  };
}
