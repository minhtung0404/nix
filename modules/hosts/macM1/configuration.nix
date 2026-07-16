{ config, ... }: {
  flake.darwinConfigurations = config.flake.lib.mkDarwin "aarch64-darwin" "mtnM1";

  flake.modules.darwin.mtnM1 =
    {
      pkgs,
      config,
      self,
      ...
    }:
    {
      imports = [
        self.modules.darwin.system-desktop

        self.modules.darwin.minhtung0404
        self.modules.darwin.entertainment
      ];

      system.primaryUser = "minhtung0404";
      mtn = {
        constants.username = "minhtung0404";
        services = {
          my-kanata.configFile = [
            "apple"
            "gm610"
          ];

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
