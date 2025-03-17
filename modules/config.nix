{ lib, ... }:
let inherit (lib) types mkOption;
in {
  options.minhtung0404 = {
    username = mkOption {
      type = types.str;
      default = "minhtung0404";
      example = "abcxyz";
      description = ''
        Your username for logging
      '';
    };
  };
}
