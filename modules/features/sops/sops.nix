{ inputs, ... }:
{
  flake-file.inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.sops.nixos = {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
  };

  den.aspects.sops.darwin = {
    imports = [
      inputs.sops-nix.darwinModules.sops
    ];
  };

  # shared by nixos and darwin
  den.aspects.sops.os =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.mtn.programs.sops;
    in
    {
      options.mtn.programs.sops = {
        file = lib.mkOption {
          type = lib.types.path;
          description = "Path to the default sops file";
        };
      };
      config = {
        services.openssh.enable = true;
        sops.defaultSopsFile = cfg.file;
      };
    };
}
