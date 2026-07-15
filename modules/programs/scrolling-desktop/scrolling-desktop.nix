{
  flake.modules.nixos.scrollingDesktop = { self, ... }: {
    imports = [
      self.modules.nixos.niri
    ];
  };

  flake.modules.homeManager.scrollingDesktop = { self, ... }: {
    imports = [
      self.modules.homeManager.niri
      self.modules.generic.workspaces
    ];
  };
}
