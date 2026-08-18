{
  flake-file.inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.sops =
    {
      config,
      inputs,
      self,
      ...
    }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
        self.modules.generic.sops
      ];

      home-manager = {
        extraSpecialArgs = {
          sops = config.sops;
        };
      };
    };

  flake.modules.darwin.sops = { inputs, self, ... }: {
    imports = [
      inputs.sops-nix.darwinModules.sops
      self.modules.generic.sops
    ];
  };

  flake.modules.generic.sops =
    {
      inputs,
      config,
      lib,
      ...
    }:
    with { inherit (lib) types mkOption mkEnableOption; };
    let
      cfg = config.mtn.programs.sops;
    in
    {
      options.mtn.programs.sops = {
        file = mkOption {
          type = types.path;
          description = "Path to the default sops file";
        };
      };
      config = {
        services.openssh.enable = true;
        sops.defaultSopsFile = cfg.file;
      };
    };
}
