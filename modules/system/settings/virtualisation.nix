{
  flake.modules.nixos.virtualisation =
    { config, pkgs, ... }:
    {
      virtualisation.podman = {
        enable = true;
        extraPackages = [ pkgs.slirp4netns ];
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      virtualisation.oci-containers.backend = "podman";

      virtualisation.virtualbox.host.enable = false;
      users.extraGroups.vboxusers.members = [ config.mtn.constants.username ];
    };

}
