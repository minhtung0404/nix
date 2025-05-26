{ config, lib, ... }:
with { inherit (lib) types mkOption mkEnableOption; };
let cfg = config.mtn.programs.sops;
in {
  options.mtn.programs.sops = {
    enable = mkEnableOption "Enable sops configuration";
    file = mkOption {
      type = types.path;
      description = "Path to the default sops file";
    };
  };
  config = lib.mkIf cfg.enable {
    sops.defaultSopsFile = cfg.file;
    # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
