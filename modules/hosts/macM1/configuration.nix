{ den, ... }:
{
  den.hosts.aarch64-darwin.mtnM1.users = {
    minhtung0404 = { };
    entertainment = { };
  };

  den.aspects.mtnM1.includes = [ den.aspects.system-desktop ];

  den.aspects.mtnM1.darwin =
    {
      pkgs,
      config,
      self,
      ...
    }:
    {
      imports = [
        self.modules.darwin.system-desktop
      ];

      system.primaryUser = "minhtung0404";
      wrappers.kanata.configFile = [
        "apple"
        "gm610"
      ];
      mtn = {
        constants.username = "minhtung0404";
        services = {
          edns = {
            ipv6 = true;
          };
        };
      };

      environment.variables = {
        SOPS_AGE_KEY_FILE = "/Users/minhtung0404/.config/sops/age/keys.txt";
      };

      system.stateVersion = 6;
    };
}
