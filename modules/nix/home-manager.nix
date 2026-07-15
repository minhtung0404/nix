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
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      # home-manager.sharedModules = [
      #   self.modules.homeManager.default
      # ];
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
