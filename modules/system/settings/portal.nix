{
  flake.modules.nixos.portal = { pkgs, ... }: {
    # Portals
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = true;
      # gtk portal needed to make gtk apps happy
      extraPortals = [
        pkgs.kdePackages.xdg-desktop-portal-kde
        pkgs.xdg-desktop-portal-gtk
      ];

      config.sway.default = [
        "wlr"
        "kde"
        "kwallet"
      ];
      config.niri = {
        default = [
          "kde"
          "gnome"
          "gtk"
        ];
        # "org.freedesktop.impl.portal.Access" = "gtk";
        # "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Secret" = "kwallet";
        "org.freedesktop.impl.portal.FileChooser" = "kde";
        "org.freedesktop.impl.portal.OpenURI" = "kde";
      };
    };

  };
}
