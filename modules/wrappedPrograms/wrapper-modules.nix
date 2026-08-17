{ self, inputs, ... }: {
  flake-file.inputs = {
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [
    inputs.wrappers.flakeModules.wrappers
  ];

  perSystem = { pkgs, system, ... }: {
    packages.kak = self.wrappers.kakoune.wrap {
      inherit pkgs;
      kak-tree-sitter = self.packages.${system}.kak-tree-sitter;
    };
    wrappers.control_type = "build";
    wrappers.packages = {
      noctalia-shell = true;
      niri = true;
      kanata = true;
      kitty = true;
      kak-tree-sitter = true;
      kak-lsp = true;
    };
  };
}
