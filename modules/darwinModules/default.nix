{ overlays, inputs, ... }: {
  nixpkgs = {
    config.allowUnfree = true;
    overlays = overlays;
  };

  imports = [ ./services/kanata/darwin.nix ./services/edns ];
}
