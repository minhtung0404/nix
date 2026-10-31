{
  den.aspects.udev.nixos = { pkgs, ... }: {
    # udev configurations
    services.udev.packages = with pkgs; [
      qmk-udev-rules # For keyboards
    ];

  };
}
