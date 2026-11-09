{
  # ZeroTier daemon (nix-darwin has no zerotier service, so nixos only); join a network
  # once by hand: sudo zerotier-cli join <network-id>
  den.aspects.zerotier.nixos.services.zerotierone.enable = true;
}
