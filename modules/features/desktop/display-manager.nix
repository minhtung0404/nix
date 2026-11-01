{
  den.aspects.displayManager.nixos =
    { pkgs, ... }:
    let
      # animated pixel-art sakura login screen
      sddmTheme = pkgs.sddm-astronaut.override { embeddedTheme = "pixel_sakura"; };
    in
    {
      services.displayManager.sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        wayland.enable = true;
        wayland.compositor = "kwin";
        theme = "sddm-astronaut-theme";
        # QML modules the theme needs; only seen by the greeter
        extraPackages = [ sddmTheme ];
        settings.Theme = {
          CursorTheme = "breeze_cursors";
          CursorSize = 24;
        };
      };

      # sddm looks up themes and cursors in the system profile
      environment.systemPackages = [
        sddmTheme
        pkgs.kdePackages.breeze # breeze_cursors
      ];
    };
}
