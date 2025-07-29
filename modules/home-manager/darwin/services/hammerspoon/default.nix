{ pkgs, ... }:
let
  spoons = pkgs.fetchFromGitHub {
    owner = "Hammerspoon";
    repo = "Spoons";
    rev = "95958fc6091491e8269ec2dfc6b97d4a91af9205";
    hash = "sha256-NCKuBg7opn8BeP1FTpG0cchYdjlea6sbAaVpX6OApxg=";
  };
  hs-config = pkgs.stdenv.mkDerivation {
    name = "hammerspoon-config";

    srcs = [
      ./config
      spoons
    ];
    unpackPhase = ''
      mkdir -p source
      mkdir -p source/Spoons
      cp -r ${./config}/* source
      # cp -r ${spoons}/Source/EmmyLua.spoon source/Spoons
    '';

    installPhase = ''
      mkdir -p $out
      cp -r source/* $out/
    '';
  };
in
{
  targets.darwin.defaults = {
    "org.hammerspoon.Hammerspoon" = {
      MJConfigFile = "${hs-config}/init.lua";
    };
  };
}
