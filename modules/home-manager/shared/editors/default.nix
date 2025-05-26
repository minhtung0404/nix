{
  myLib,
  lib,
  config,
  ...
}:
{
  imports =
    [
      ./kakoune
    ]
    ++ (myLib.extendModules (myLib.extends lib config "programs") [
      ./nvf.nix
    ]);
}
