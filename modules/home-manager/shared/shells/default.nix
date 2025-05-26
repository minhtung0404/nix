{
  myLib,
  lib,
  config,
  ...
}:
{
  imports =
    [
    ]
    ++ (myLib.extendModules (myLib.extends lib config "programs") [
      ./fish
    ]);
}
