{
  flake.modules.generic.overleaf = { config, ... }: {
    sops.secrets."overleaf" = {
      owner = config.mtn.constants.username;
      sopsFile = ./overleaf.yaml;
    };
  };
}
