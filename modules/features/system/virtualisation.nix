{ lib, ... }:
{
  den.aspects.virtualisation = {
    nixos =
      { pkgs, ... }:
      {
        virtualisation.podman = {
          enable = true;
          extraPackages = [ pkgs.slirp4netns ];
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        virtualisation.oci-containers.backend = "podman";

        virtualisation.virtualbox.host.enable = false;
        users.groups.vboxusers = { };
      };

    # every user of the host is in vboxusers (nix-darwin users have no
    # extraGroups)
    provides.to-users =
      { host, ... }:
      lib.optionalAttrs (host.class == "nixos") {
        user.extraGroups = [ "vboxusers" ];
      };
  };
}
