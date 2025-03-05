{ ... }: {
  imports = [ ./darwin.nix ];
  xdg.configFile."kanata/config".source = ./default_configs;
}
