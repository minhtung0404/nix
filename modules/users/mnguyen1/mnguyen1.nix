{
  den,
  ...
}:
let
  user = "mnguyen1";
in
{
  den.aspects.${user} = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "fish")
      den.aspects.gsync
      den.aspects.tex
      # home config of the host aspects (desktop, …)
      den.batteries.host-aspects
    ];

    homeManager =
      {
        pkgs,
        config,
        ...
      }:
      {
        mtn = {
          linux.graphical = {
            startup = [
              pkgs.obsidian
              config.mtn.linux.graphical.defaults.webBrowser.package
            ];

            defaults = {
              webBrowser = {
                package = config.programs.zen-browser.finalPackage;
                desktopFile = "zen.desktop";
              };
            };
          };
        };

        home.packages = with pkgs; [
          google-chrome
        ];
      };
  };
}
