{
  flake.modules.nixos.sound = { ... }: {
    # Enable sound.
    services.pipewire = {
      enable = true;
      # alsa is optional
      alsa.enable = true;
      alsa.support32Bit = true;

      pulse.enable = true;
    };
  };
}
