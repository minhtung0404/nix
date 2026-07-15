{
  flake.modules.nixos.monitorBacklight =
    { pkgs, ... }:
    {
      # Monitor backlight
      hardware.i2c.enable = true;
      services.ddccontrol.enable = true;
      environment.systemPackages = [
        pkgs.luminance
        pkgs.ddcutil
      ];
    };

}
