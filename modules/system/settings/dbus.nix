{
  flake.modules.nixos.dbus = { pkgs, ... }: {
    # D-Bus
    services.dbus.packages = with pkgs; [ gcr ];
  };
}
