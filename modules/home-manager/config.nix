{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.mtn = {
    username = mkOption {
      type = types.str;
      default = "minhtung0404";
      example = "abcxyz";
      description = ''
        Your username for logging
      '';
    };
    editor = mkOption {
      type = types.str;
      default = "kak";
      example = "kak";
      description = ''
        Your favorite editor
      '';
    };
  };
}
