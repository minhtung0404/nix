{
  flake.modules.nixos.plasma = { pkgs, ... }: {
    # Plasma!
    services.desktopManager.plasma6.enable = true;
    environment.systemPackages = with pkgs; [
      kdePackages.qtwebsockets
    ];
  };
}
