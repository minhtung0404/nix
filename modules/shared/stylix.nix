{
  pkgs,
  config,
  ...
}:
{
  stylix = {
    enable = true;

    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = config.stylix.fonts.monospace;
    };
  };
}
