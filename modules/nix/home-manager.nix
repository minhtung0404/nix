{
  flake.modules.nixos.homeManager =
    {
      self,
      inputs,
      overlays,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = {
        inherit
          self
          inputs
          overlays
          ;
      };
    };
}
