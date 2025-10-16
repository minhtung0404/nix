{
  myLib,
  lib,
  config,
  ...
}:
{
  imports = [
    ./kakoune.nix
  ]
  ++ (myLib.extendModules (myLib.extends lib config "programs") [
  ]);
}
