{
  config,
  inputs,
  lib,
  myLib,
  overlays,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ../shared
    ../shared/services/kanata/linux.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.sharedModules = [
        self.homeManagerModules.default
        ../home-manager/nixos
        {
          home.packages = with pkgs; [ home-manager ];
        }
      ];
      home-manager.extraSpecialArgs = {
        inherit
          self
          inputs
          myLib
          overlays
          ;
      };
    }
    inputs.sops-nix.nixosModules.sops
    inputs.niri.nixosModules.niri
  ];
  nixpkgs.overlays = [ self.overlays.default ];

  programs.niri.enable = true;

  services.udisks2.enable = true;

}
