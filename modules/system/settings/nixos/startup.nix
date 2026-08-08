{
  flake.modules.homeManager.nixosStartup =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.mtn.linux.graphical;
    in
    {
      options.mtn.linux.graphical = {
        startup = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          description = "List of packages to include in ~/.config/autostart";
          default = [
            cfg.defaults.webBrowser.package
            cfg.defaults.discord.package
          ];
        };
      };

      config = {
        xdg.configFile =
          let
            f = pkg: {
              name = "autostart/${pkg.name}.desktop";
              value = {
                source =
                  let
                    srcFile = pkgs.runCommand "${pkg.name}-startup" { } ''
                      mkdir -p $out
                      cp $(ls -d ${pkg}/share/applications/*.desktop | head -n 1) $out/${pkg.name}.desktop
                    '';
                  in
                  "${srcFile}/${pkg.name}.desktop";
              };
            };
            autoStartup = lib.listToAttrs (map f cfg.startup);
          in
          autoStartup;

      };
    };
}
