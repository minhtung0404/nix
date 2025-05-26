{ pkgs, ... }:
let
  spoons = pkgs.fetchFromGitHub {
    owner = "Hammerspoon";
    repo = "Spoons";
    rev = "95958fc6091491e8269ec2dfc6b97d4a91af9205";
    hash = "sha256-NCKuBg7opn8BeP1FTpG0cchYdjlea6sbAaVpX6OApxg=";
  };
in
{
  xdg.configFile.hammerspoon = {
    source = ./config;
    recursive = true;
  };
  xdg.configFile."hammerspoon/Spoons/EmmyLua.spoon" = {
    source = "${spoons}/Source/EmmyLua.spoon";
    recursive = true;
  };
  targets.darwin.defaults = {
    "org.hammerspoon.Hammerspoon" = {
      MJConfigFile = "~/.config/hammerspoon/init.lua";
    };
  };
}
