{
  flake.modules.nixos.portal = { pkgs, lib, ... }: {
    # Portals
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];

      config.niri = {
        default = lib.mkForce [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = lib.mkForce "kwallet";
      };
    };

  };
}
