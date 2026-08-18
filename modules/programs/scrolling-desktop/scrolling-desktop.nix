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
      ];
      programs.niri = {
        enable = true;
        package = config.wrappers.niri.wrapper;
      };
      services.displayManager.defaultSession = lib.mkForce "niri";
      wrappers.niri = {
        noctalia = config.wrappers.noctalia-shell.wrapper;
        terminal = config.wrappers.kitty.wrapper;
        wallpaper = config.mtn.constants.mirai;
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
