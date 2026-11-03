{
  # polkit authentication agent for the niri session (password prompts for
  # udisks, NetworkManager, …); under Plasma, plasma-polkit-agent does this
  den.aspects.polkitAgent.nixos =
    { pkgs, ... }:
    {
      security.polkit.enable = true;

      systemd.user.services.polkit-kde-agent = {
        description = "KDE PolicyKit Authentication Agent";
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
          Restart = "on-failure";
          TimeoutStopSec = "5sec";
          Slice = "background.slice";
        };
      };
    };
}
