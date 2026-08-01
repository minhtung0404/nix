{
  flake.modules.nixos.udev = { pkgs, ... }: {
    # udev configurations
    services.udev.packages = with pkgs; [
      qmk-udev-rules # For keyboards
    ];

  };
}
