{ config, self, ... }:
let
  inherit (config.mtn) images;
in
{
  den.aspects.scrollingDesktop.nixos =
    {
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
        wallpaper = images.mirai;
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
}
