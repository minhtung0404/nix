{
  flake.modules.homeManager.macosDefaultApps =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        aldente
        hidden-bar
        raycast
        skimpdf
      ];

      mtn = {
        services = {
          my-sketchybar.enable = true;
          my-aerospace.enable = true;
        };
      };
    };
}
