{ inputs, ... }: {
  flake-file.inputs = {
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [
    inputs.wrappers.flakeModules.wrappers
  ];

  perSystem = { pkgs, ... }: {
    wrappers.control_type = "build";
    wrappers.packages = {
      noctalia-shell = true;
      niri = true;
      kanata = true;
    };
  };
}
