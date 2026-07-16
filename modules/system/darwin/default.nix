{
  flake.modules.darwin.default =
    {
      config,
      inputs,
      lib,
      pkgs,
      ...
    }:
    {
      services.tailscale.enable = true;

      system.activationScripts = {
        postActivation = {
          text = lib.mkOrder 1600 ''
            echo "-----------------------------------------------"
            echo "Permission required ..."
            echo "kanata: Please enable Input Mornitoring/Full Disk Access for ${config.mtn.services.my-kanata.package}/bin/kanata"
            echo "rclone: Please enable Full Disk Access for ${pkgs.rclone}/bin/rclone"
          '';
        };
      };

    };
}
