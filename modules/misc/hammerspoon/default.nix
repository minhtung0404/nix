{ pkgs, ... }:
let
  spoons = pkgs.fetchFromGitHub {
    owner = "Hammerspoon";
    repo = "Spoons";
    rev = "95958fc6091491e8269ec2dfc6b97d4a91af9205";
    hash = "sha256-NCKuBg7opn8BeP1FTpG0cchYdjlea6sbAaVpX6OApxg=";
  };
in {
  xdg.configFile.hammerspoon = {
    source = ./config;
    recursive = true;
  };
  xdg.configFile."hammerspoon/Spoons/EmmyLua.spoon" = {
    source = "${spoons}/Source/EmmyLua.spoon";
    recursive = true;
  };
  home.sessionPath = [ "/usr/bin" "/bin" "/usr/sbin" "/sbin" ];
  home.activation = {
    hammerspoon = ''
      run /usr/bin/defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"'';
  };
}
