{
  den.aspects.plasma = {
    nixos =
      { pkgs, ... }:
      {
        # Plasma!
        services.desktopManager.plasma6.enable = true;
        environment.systemPackages = with pkgs; [
          kdePackages.qtwebsockets
        ];
      };

    # kded's gtkconfig module (kde-gtk-config, required by plasma6) pushes KDE's
    # GTK modules into running GTK3 apps when kded starts mid-session, and they
    # segfault under niri. See debug-gtkconfig-crash.md.
    # kded6 (KF6) still reads its module settings from kded5rc.
    # kwriteconfig6 instead of a managed file so KDE can still write kded5rc.
    provides.to-users.homeManager =
      { lib, pkgs, ... }:
      {
        home.activation.disableKdedGtkconfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
            --file kded5rc --group Module-gtkconfig --key autoload false
        '';
      };
  };
}
