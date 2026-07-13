{
  flake.modules.generic.constants = { lib, ... }: {
    options.systemConstants = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
    };

    config.systemConstants = {

    };
  };
}
