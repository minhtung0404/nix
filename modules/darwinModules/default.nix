{ inputs, outputs, ... }: {
  nixpkgs = {
    config.allowUnfree = true;
    overlays = outputs.overlays.default;
  };

  imports = [ ./services/kanata/darwin.nix ./services/edns ];
}
