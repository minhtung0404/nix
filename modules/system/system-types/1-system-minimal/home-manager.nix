{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
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
