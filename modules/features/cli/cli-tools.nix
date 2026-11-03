{ den, ... }:
{
  den.aspects.cliTools.os = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # An editor
      kakoune
      wget # A simple fetcher
    ];
  };

  den.aspects.cliTools.nixos = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      ## System monitoring tools
      usbutils # lsusb and friends
      pciutils # lspci and friends
      psmisc # killall, pstree, ...
      lm_sensors # sensors
    ];
  };

  # homeManager on a host-included aspect is dropped by den; to-users routes it
  # to every user of the host
  den.aspects.cliTools.provides.to-users.includes = with den.aspects; [
    git
    ssh
    rebuild
    devTools
    secretTools
    fonts
    vscode
  ];
  den.aspects.cliTools.provides.to-users.homeManager = { pkgs, ... }: {
    home.packages = with pkgs; [
      ## Core / shell utilities
      coreutils
      entr
      grc
      tldr

      ## Search & file tools
      dust
      fd
      ripgrep

      ## Data / JSON tools
      jq
      jqp

      ## System monitoring
      btop

      ## Networking
      curl

      ## Archives
      unzip
      zip
    ];

    home.shell.enableFishIntegration = true;

    programs.bat = {
      enable = true;
      config = {
        theme = "GitHub";
      };
    };

    programs.eza.enable = true;

    programs.man = {
      enable = true;
      package = pkgs.man;
      generateCaches = true;
    };

    programs.zoxide = {
      enable = true;
      options = [ "--cmd j" ];
    };

    programs.fzf = {
      enable = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    services.tldr-update.enable = true;
  };
}
