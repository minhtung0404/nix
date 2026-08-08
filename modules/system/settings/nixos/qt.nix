{
  flake.modules.homeManager.nixosQt = { pkgs, ... }: {
    ## Qt
    qt.enable = true;
    qt.platformTheme.name = "kde";
    qt.platformTheme.package = with pkgs.kdePackages; [
      plasma-integration
      systemsettings
    ];
    qt.style.package = [ pkgs.kdePackages.breeze ];
    qt.style.name = "Breeze";

  };
}
