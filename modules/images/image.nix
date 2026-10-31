{ lib, ... }:
{
  # flake-level data, read by the niri and noctalia wrappers
  options.mtn.images = lib.mkOption {
    type = lib.types.attrsOf lib.types.path;
    default = { };
  };

  config.mtn.images = {
    "25th-hour" = ./25th-hour.heic;
    amira = ./amira.jpeg;
    amira_squared = ./amira_squared.jpeg;
    mirai = ./kuriyama_mirai.png;
  };
}
