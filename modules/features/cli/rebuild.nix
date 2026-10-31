{
  den.aspects.rebuild =
    { host, ... }:
    {
      homeManager.programs.fish.functions.rebuild =
        {
          nixos = {
            body = ''
              sudo nixos-rebuild switch --flake /etc/nixos
            '';
            wraps = "nixos-rebuild";
          };

          darwin = {
            body = ''
              sudo darwin-rebuild switch --flake ~/.config/nix/
            '';
            wraps = "darwin-rebuild";
          };
        }
        .${host.class};
    };
}
