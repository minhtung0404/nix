{ inputs, ... }: {
  nixpkgs = {
    config.allowUnfree = true;
    overlays = import ../overlays.nix inputs;
  };

  imports = [ ./services/kanata/darwin.nix ./services/network/edns ];
}
