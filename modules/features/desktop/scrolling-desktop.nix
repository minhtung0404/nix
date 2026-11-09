{ den, self, ... }:
{
  # niri + noctalia, logged into through noctalia's greeter
  den.aspects.scrollingDesktop.includes = [ den.aspects.noctaliaGreeter ];

  den.aspects.scrollingDesktop.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # Qt's wayland plugin: niri sets QT_QPA_PLATFORM=wayland
      environment.systemPackages = [ pkgs.kdePackages.qtwayland ];

      imports = [
        self.wrappers.niri.install
        self.wrappers.noctalia.install
        self.wrappers.kitty.install
        self.wrappers.kanshi.install
      ];

      programs.niri = {
        enable = true;
        package = config.wrappers.niri.wrapper;
      };
      services.displayManager.defaultSession = lib.mkForce "niri";
      wrappers.niri = {
        runtimePkgs = [
          config.wrappers.noctalia.wrapper
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
