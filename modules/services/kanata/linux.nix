{
  flake.modules.nixos.kanata =
    {
      self,
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        self.wrappers.kanata.install
      ];
      config = {
        systemd.services.kanata = {
          description = "Service for kanata keyboard";
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "simple";
            ExecStart = lib.getExe config.wrappers.kanata.wrapper;
            Restart = "on-failure";
            Environment = [ "LAPTOP=pc" ];
          };
        };
      };
    };
}
