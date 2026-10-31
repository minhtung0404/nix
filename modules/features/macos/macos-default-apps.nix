{
  den.aspects.macosDefaultApps.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        aldente
        hidden-bar
        raycast
        skimpdf
      ];
    };
}
