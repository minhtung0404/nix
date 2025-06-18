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
      ./git.nix
      ./ssh.nix
      ./librewolf.nix
    ]);
}
