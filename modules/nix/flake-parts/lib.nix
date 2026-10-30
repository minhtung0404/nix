{
  lib,
  ...
}:
{
  # Helper functions shared across modules
  # (system configurations are built by den, see modules/nix/den.nix)

  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {
    mkPackageWithDesktopOption =
      opts:
      lib.mkOption (
        {
          type = lib.types.submodule {
            options = {
              package = lib.mkOption {
                type = lib.types.package;
                description = "The package for " + lib.description;
              };
              desktopFile = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description =
                  "The desktop file name for " + lib.description + ", defaults to [packagename].desktop";
              };
            };
          };
        }
        // opts
      );
  };
}
