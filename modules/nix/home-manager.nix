{
  flake.modules.nixos.homeManager =
    {
      self,
      inputs,
      myLib,
      overlays,
      ...
    }:
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.sharedModules = [
        self.homeManagerModules.default
      ];
      home-manager.extraSpecialArgs = {
        inherit
          self
          inputs
          myLib
          overlays
          ;
      };
    };
}
