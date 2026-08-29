{
  flake.modules.nixos.cliTools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      kakoune # An editor
      wget # A simple fetcher

      ## System monitoring tools
      usbutils # lsusb and friends
      pciutils # lspci and friends
      psmisc # killall, pstree, ...
      lm_sensors # sensors
    ];
  };

  flake.modules.darwin.cliTools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # An editor
      kakoune
      wget # A simple fetcher
    ];
  };
  flake.modules.homeManager.cliTools = { self, pkgs, ... }: {
    imports = [
      self.modules.homeManager.git
      self.modules.homeManager.ssh
      self.modules.homeManager.rebuild
    ];
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

      ## Git
      lazygit

      ## Networking
      curl

      ## Formatters
      nixfmt

      ## Build tools
      gnumake

      ## Archives
      unzip
      zip

      ## Editors
      vscode

      ## Secrets & security
      sops
      bitwarden-cli

      ## Dev environments / containers
      devenv
      podman

      ## Fonts
      nerd-fonts.fira-code

      ## AI
      claude-code
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
