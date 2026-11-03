{ den, lib, ... }:
{
  # desktop home: reaches the users that include den.batteries.host-aspects
  den.aspects.desktopHome =
    { host, ... }:
    {
      includes =
        (with den.aspects; [
          zenBrowser
          kakoune
          vesktop
          communication
          office
        ])
        ++ lib.optional (host.class == "nixos") den.aspects.desktopHomeNixos
        ++ lib.optional (host.class == "darwin") den.aspects.desktopHomeMacos;

      homeManager.mtn.programs.my-kakoune.enable-fish-session = true;
    };

  # desktop home on nixos hosts
  den.aspects.desktopHomeNixos.includes = with den.aspects; [
    copyPaste
    nixosMime
    nixosStartup
    nixosGtk
    nixosQt
    media
    diskTools
  ];

  # desktop home on darwin hosts
  den.aspects.desktopHomeMacos.includes = with den.aspects; [
    macosDefaults
    macosDock
    aerospace
    sketchybar
    hammerspoon
    macosDefaultApps
    lctl
  ];
}
