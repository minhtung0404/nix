let
  # the home-manager nixos/darwin module itself is imported by den
  # for every host that has a user with the homeManager class
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
  flake-file.inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.homeManager = homeManagerConfig;

  flake.modules.darwin.homeManager = homeManagerConfig;
}
