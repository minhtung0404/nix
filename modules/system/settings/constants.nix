{
  flake.modules.generic.constants = { lib, ... }: {
    options.mtn.constants = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
    };
  };
}
