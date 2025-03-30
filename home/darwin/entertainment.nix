{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  mtn = {
    hm = {
      enable = true;
      darwin = true;
    };

    username = "entertainment";
  };
}
