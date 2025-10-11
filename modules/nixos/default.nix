{
  config,
  inputs,
  lib,
  myLib,
  outputs,
  overlays,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ../shared
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.sharedModules = [
        outputs.homeManagerModules.default
        {
          home.packages = with pkgs; [ home-manager ];
        }
      ];
      home-manager.extraSpecialArgs = {
        inherit
          self
          inputs
          outputs
          myLib
          overlays
          ;
      };
    }
    inputs.sops-nix.nixosModules.sops
    inputs.niri.nixosModules.niri
  ];
  nixpkgs.overlays = [ outputs.overlays.default ];
}
