{ lib, ... }:
{
  den.aspects.kvm = {
    nixos =
      { pkgs, ... }:
      {
        virtualisation.libvirtd.enable = true;

        programs.virt-manager.enable = true;

        environment.systemPackages = with pkgs; [
          qemu
        ];
      };

    # every user of a host with kvm can manage the VMs (nix-darwin users have
    # no extraGroups)
    provides.to-users =
      { host, ... }:
      lib.optionalAttrs (host.class == "nixos") {
        user.extraGroups = [
          "libvirtd"
          "kvm"
        ];
      };
  };
}
