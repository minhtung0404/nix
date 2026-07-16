{
  flake.modules.generic.kanata =
    {
      self,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib)
        mkEnableOption
        mkPackageOption
        mkOption
        types
        literalExpression
        ;
    in
    {
      options.mtn.services.my-kanata = {
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

    };
}
