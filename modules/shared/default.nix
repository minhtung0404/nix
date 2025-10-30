{
  self,
  inputs,
  myLib,
  overlays,
  ...
}:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ self.overlays.default ];
  };

  imports = [
    ./config.nix
    ./services/edns
    ./programs/sops.nix
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
    }
  ];

  nix = {
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
      extra-platforms = x86_64-darwin aarch64-darwin
      extra-nix-path = nixpkgs=flake:nixpkgs
    '';
  };
  nixpkgs.flake.setNixPath = true;

  programs.fish = {
    enable = true;
    vendor.completions.enable = true;
  };
}
