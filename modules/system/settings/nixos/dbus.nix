{
  den.aspects.dbus.nixos = { pkgs, ... }: {
    # D-Bus
    services.dbus.packages = with pkgs; [ gcr_4 ];
  };
}
