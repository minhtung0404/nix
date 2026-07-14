{
  flake.modules.nixos.battery = { config, pkgs, ... }: {
    # Power Management
    services.upower = {
      enable = true;
      criticalPowerAction = "Hibernate";

      usePercentageForPolicy = true;
      percentageCritical = 5;
      percentageLow = 10;
    };
    services.tlp.enable = true;
    services.tlp.settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 30;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      USB_AUTOSUSPEND = 0;
    };
    services.power-profiles-daemon.enable = false;
    services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
    systemd.sleep.settings.Sleep.HibernateDelaySec = "4h";

    systemd.services.lock-before-sleep = {
      description = "Lock screen before suspend";
      before = [ "sleep.target" ];
      wantedBy = [ "sleep.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.swaylock}/bin/swaylock -f";
        User = config.mtn.constants.username;
      };
    };
  };
}
