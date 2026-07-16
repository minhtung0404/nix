let
  homeManagerConfig =
    {
      self,
      inputs,
      overlays,
      ...
    }:
    {
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
in
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
        homeManagerConfig
      ];
    };

  flake.modules.darwin.homeManager =
    {
      self,
      inputs,
      overlays,
      ...
    }:
    {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        homeManagerConfig
      ];
    };
}
