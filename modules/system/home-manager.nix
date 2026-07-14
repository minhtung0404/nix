{
  flake.modules.homeManager.default =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      config = {
        home.stateVersion = "26.05";
        programs.home-manager.enable = true;
      };
    };
}
