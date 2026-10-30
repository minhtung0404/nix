{
  inputs,
  self,
  lib,
  ...
}:
{
  # every user gets a home-manager environment, nested in its host
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  # Migration bridge: class modules still reach `self.modules.*` through their
  # `self` argument (often inside `imports`), which only works as a specialArg.
  # Drop this once everything is a den aspect.
  den.schema.host.imports = [
    (
      { config, ... }:
      {
        instantiate =
          let
            builder =
              {
                nixos = inputs.nixpkgs.lib.nixosSystem;
                darwin = inputs.nix-darwin.lib.darwinSystem;
              }
              .${config.class};
          in
          args:
          builder (
            args
            // {
              specialArgs = (args.specialArgs or { }) // {
                inherit self inputs;
              };
            }
          );
      }
    )
  ];
}
