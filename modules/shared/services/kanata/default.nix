{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkPackageOption
    mkOption
    listOf
    types
    literalExpression
    ;
  cfg = config.mtn.services.my-kanata;
in
{
  imports = [
    ./darwin.nix
    ./linux.nix
  ];
  options.mtn.services.my-kanata = {
    enable = mkEnableOption "my-kanata";
    darwin = mkEnableOption "my-kanata-darwin";
    linux = mkEnableOption "my-kanata-linux";

    package = mkPackageOption pkgs "kanata-with-cmd" { };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "[ pkgs.jq ]";
      description = ''
        Extra packages to add to PATH.
      '';
    };

    configFile = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = literalExpression ''[ "apple" ]'';
      description = ''
        path to the config
      '';
    };
  };

}
