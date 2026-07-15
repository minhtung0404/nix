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

      wget
    ];
  };

  flake.modules.darwin.cliTools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      kakoune # An editor
      wget # A simple fetcher

      ## System monitoring tools
      usbutils # lsusb and friends
      pciutils # lspci and friends
      psmisc # killall, pstree, ...
      lm_sensors # sensors

      wget
    ];
  };
  flake.modules.homeManager.cliTools = { self, pkgs, ... }: {
    imports = [
      self.modules.homeManager.git
      self.modules.homeManager.ssh
      self.modules.homeManager.rebuild
    ];
    home.packages = with pkgs; [
      coreutils
      curl
      dust
      entr
      grc
      btop
      lazygit
      nerd-fonts.fira-code
      nixfmt
      podman
      ripgrep
      stylua
      tldr

      mtn-kakoune
      gnumake
      unzip
      zip
      deluge
    ];

    home.shell.enableFishIntegration = true;

    programs.bat = {
      enable = true;
      config = {
        theme = "GitHub";
      };
    };

    programs.eza.enable = true;

    programs.fd.enable = true;

    programs.jq.enable = true;
    programs.jqp.enable = true;

    programs.man = {
      enable = true;
      package = pkgs.man;
      generateCaches = true;
    };

    programs.vscode.enable = true;

    programs.nushell.enable = true;

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
      config.global.load_dotenv = true;
    };

    services.tldr-update.enable = true;
  };
}
