# Test a NixOS host in a QEMU VM before switching to it:
#
#   nix run .#vm-mtnWork
#
# Only `virtualisation.vmVariant` is touched, so the real system is unaffected.
# The user is logged in on tty1; its password is "test".
{
  den,
  inputs,
  lib,
  ...
}:
let
  # host -> user to log in
  vms = {
    mtnWork = "mnguyen1";
    mtnPC = "minhtung0404";
    test = "tester";
  };
in
{
  den.aspects = lib.mapAttrs (_: user: {
    includes = [ (den.batteries.vm-autologin user) ];
    nixos.virtualisation.vmVariant = {
      users.users.${user}.initialPassword = "test";
      # NixOS defaults (1 core, 1 GiB RAM) are too small for a desktop session
      virtualisation.cores = 4;
      virtualisation.memorySize = 8192;
      # virtio-gpu with GL so niri can start
      virtualisation.qemu.options = [
        "-vga none"
        "-device virtio-vga-gl"
        "-display gtk,gl=on"
      ];
    };
  }) vms;

  perSystem =
    { pkgs, ... }:
    {
      packages = lib.mapAttrs' (
        name: _:
        lib.nameValuePair "vm-${name}" (
          pkgs.writeShellApplication {
            name = "vm-${name}";
            text =
              let
                host = inputs.self.nixosConfigurations.${name}.config;
              in
              ''
                ${host.system.build.vm}/bin/run-${host.networking.hostName}-vm "$@"
              '';
          }
        )
      ) vms;
    };
}
