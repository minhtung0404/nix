{
  myLib,
  lib,
  config,
  ...
}:
{
  imports = [
    ./librewolf.nix
    ./zen-browser.nix
  ]
  ++ (myLib.extendModules (myLib.extends lib config "programs") [
    ./git.nix
    ./ssh.nix
  ]);
}
