{
  flake.modules.nixos.scrollingDesktop =
    {
      self,
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        self.wrappers.niri.install
        self.wrappers.noctalia-shell.install
      ];
      programs.niri = {
        enable = true;
        package = config.wrappers.niri.wrapper;
      };
      wrappers.niri = {
        noctalia = config.wrappers.noctalia-shell.wrapper;
        terminal = pkgs.kitty;
        wallpaper = config.mtn.constants.mirai;
      };
    };

  flake.modules.homeManager.scrollingDesktop = { self, ... }: {
    imports = [
      self.modules.homeManager.niri
      self.modules.generic.workspaces
    ];
  };
}
