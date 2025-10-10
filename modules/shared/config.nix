{ lib, ... }:
let
  inherit (lib) types mkEnableOption;
in
{
  options.mtn = {
    darwin = mkEnableOption "is-darwin";
  };
}
