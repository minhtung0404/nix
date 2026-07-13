{
  flake.modules.homeManager.vesktop =
    { ... }:
    {
      programs.vesktop = {
        enable = true;
        vencord = {
          themes = {
            chillax = ./chillax.theme.css;
          };
          # settings.enabledThemes = "chillax.css";
        };
      };
    };
}
