{
  den.aspects.boot.nixos =
    {
      lib,
      pkgs,
      ...
    }:
    {
      ## Boot Configuration
      # Set kernel version to latest
      boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;
      # Use the systemd-boot EFI boot loader.
      boot = {
        loader.timeout = 10;
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        supportedFilesystems.ntfs = true;
      };
    };
}
