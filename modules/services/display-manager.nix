{
  den.aspects.displayManager.nixos = {
    # Enable the GNOME Desktop Environment.
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
