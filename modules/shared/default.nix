{
  outputs,
  ...
}:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ outputs.overlays.default ];
  };

  imports = [
    ./services/kanata/darwin.nix
    ./services/edns
    ./programs/sops.nix
  ];

  nix = {
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
      extra-platforms = x86_64-darwin aarch64-darwin
      extra-nix-path = nixpkgs=flake:nixpkgs
    '';
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };
  nixpkgs.flake.setNixPath = true;

  programs.fish = {
    enable = true;
    vendor.completions.enable = true;
  };
}
