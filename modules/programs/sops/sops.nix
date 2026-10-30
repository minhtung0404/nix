{
  flake-file.inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.sops.nixos =
    {
      inputs,
      ...
    }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];
    };

  den.aspects.sops.darwin = { inputs, ... }: {
    imports = [
      inputs.sops-nix.darwinModules.sops
    ];
  };

  # shared by nixos and darwin
  den.aspects.sops.os =
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
