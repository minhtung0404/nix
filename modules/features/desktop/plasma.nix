{
  den.aspects.plasma.nixos = { pkgs, ... }: {
    # Plasma!
    services.desktopManager.plasma6.enable = true;
    environment.systemPackages = with pkgs; [
      kdePackages.qtwebsockets
    ];
  };
}
