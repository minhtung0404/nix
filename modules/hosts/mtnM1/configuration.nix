{ den, ... }:
{
  den.hosts.aarch64-darwin.mtnM1.users = {
    minhtung0404 = { };
    entertainment = { };
  };

  den.aspects.mtnM1.includes = [ den.aspects.system-desktop ];

  den.aspects.mtnM1.darwin = {
    wrappers.kanata.configFile = [
      "apple"
      "gm610"
    ];
    mtn = {
      services = {
        edns = {
          ipv6 = true;
        };
      };
    };

    environment.variables = {
      SOPS_AGE_KEY_FILE = "/Users/minhtung0404/.config/sops/age/keys.txt";
    };
  };
}
