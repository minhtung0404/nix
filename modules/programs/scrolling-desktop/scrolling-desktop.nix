{
  flake.modules.nixos.scrollingDesktop =
    {
      self,
      config,
      lib,
      ...
    }:
    {
      imports = [
        self.wrappers.niri.install
        self.wrappers.noctalia-shell.install
        self.wrappers.kitty.install
        self.wrappers.kanshi.install
      ];

      programs.niri = {
        enable = true;
        package = config.wrappers.niri.wrapper;
      };
      services.displayManager.defaultSession = lib.mkForce "niri";
      wrappers.niri = {
        wallpaper = config.mtn.constants.mirai;
        runtimePkgs = [
          config.wrappers.noctalia-shell.wrapper
          config.wrappers.kitty.wrapper
        ];
      };

      services.kanshi = {
        enable = true;
        package = config.wrappers.kanshi.wrapper;
        # systemd.target = "";
      };
      wrappers.kanshi = {
        runtimePkgs = [ config.wrappers.niri.wrapper ];
      };

      wrappers.kitty.fontSize = 16;
    };

  flake.modules.homeManager.scrollingDesktop = { self, ... }: {
    imports = [
      self.modules.homeManager.niri
      self.modules.generic.workspaces
    ];
  };
}
