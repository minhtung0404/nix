{ self, ... }:
{
  # shared by nixos and darwin
  den.aspects.nixpkgs.os = {
    nixpkgs = {
      config.allowUnfree = true;
      overlays = [ self.overlays.default ];
    };

    nix = {
      extraOptions = ''
        auto-optimise-store = true
        experimental-features = nix-command flakes
        extra-platforms = x86_64-darwin aarch64-darwin
        extra-nix-path = nixpkgs=flake:nixpkgs
      '';
    };
    nixpkgs.flake.setNixPath = true;

  };
}
