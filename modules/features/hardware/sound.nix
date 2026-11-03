{
  den.aspects.sound.nixos = {
    # realtime scheduling for pipewire: the rtkit daemon (D-Bus service + systemd unit),
    # not just its package
    security.rtkit.enable = true;

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
