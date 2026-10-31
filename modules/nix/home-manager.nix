{
  flake-file.inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # the home-manager nixos/darwin module itself is imported by den
  # for every host that has a user with the homeManager class
  # shared by nixos and darwin
  den.aspects.home-manager.os = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
  };
}
