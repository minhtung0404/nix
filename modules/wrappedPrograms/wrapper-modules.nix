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
    packages.kanshi = self.wrappers.kanshi.wrap {
      inherit pkgs;
      monitorOutputs = {
        "eDP-1" = {
          scale = 1.0;
          position = {
            x = 0;
            y = 0;
          };
          alias = "internal";
        };
        "Lenovo Group Limited R27qe Gen2 UTP04ABB" = {
          scale = 1.0;
          position = {
            x = -2560;
            y = 0;
          };
          alias = "home-lenovo";
        };
        "DP-2" = {
          scale = 1.0;
          position = {
            x = -1920;
            y = 0;
          };
          alias = "work";
        };
      };
      profile = {
        home = {
          output = {
            "$home-lenovo" = {
              enable = true;
            };
            "$internal" = {
              enable = true;
            };
          };
          main = "Lenovo Group Limited R27qe Gen2 UTP04ABB";
          secondary = "eDP-1";
        };
      };
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
