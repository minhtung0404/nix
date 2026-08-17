{
  flake.wrappers.kakoune = { config, pkgs, ... }: {
    config.plugins.racket = {
      src =
        (builtins.fetchTree {
          type = "git";
          url = "https://bitbucket.org/KJ_Duncan/kakoune-racket.kak.git";
          rev = "e397042009b46916ff089d79166ec0e8ca813a18";
          narHash = "sha256-IcxFmvG0jqpMCG/dT9crVRgPgMGKkic6xwrnW5z4+bc=";
        })
        + "/rc";
    };
  };
}
