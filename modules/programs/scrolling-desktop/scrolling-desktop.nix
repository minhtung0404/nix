{
  flake.modules.homeManager.scrollingDesktop = { self, ... }: {
    imports = [
      self.modules.homeManager.niri
      self.modules.generic.workspaces
    ];
  };
}
