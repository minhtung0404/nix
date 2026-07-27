{
  inputs,
  ...
}:
{
  flake.modules.homeManager.system-minimal =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      home.stateVersion = "26.05";
      programs.home-manager.enable = true;
    };
}
