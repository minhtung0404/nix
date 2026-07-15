{
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
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];
      options.mtn.programs.sops = {
        file = mkOption {
          type = types.path;
          description = "Path to the default sops file";
        };
      };
      config = {
        sops.defaultSopsFile = cfg.file;
        home-manager = {
          extraSpecialArgs = {
            sops = config.sops;
          };
        };
      };
    };
}
