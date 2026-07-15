{
  flake.modules.nixos.boot =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.mtn.nixos.luksDevices = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = "A mapping from device mount name to its path (/dev/disk/...) to be mounted on boot";
        default = { };
      };

      config = {
        ## Boot Configuration
        # Set kernel version to latest
        boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
        # Use the systemd-boot EFI boot loader.
        boot = {
          loader.timeout = 10;
          loader.systemd-boot.enable = true;
          loader.efi.canTouchEfiVariables = true;
          supportedFilesystems.ntfs = true;
        };
        boot.initrd.systemd.enable = true;
        # LUKS devices
        boot.initrd.luks.devices = builtins.mapAttrs (name: path: {
          device = path;
          preLVM = true;
          allowDiscards = true;

          crypttabExtraOpts = [
            "tpm2-device=auto"
            "fido2-device=auto"
          ];
        }) config.mtn.nixos.luksDevices;
      };
    };
}
