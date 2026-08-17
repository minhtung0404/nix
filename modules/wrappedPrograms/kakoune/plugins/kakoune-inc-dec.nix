{
  flake.wrappers.kakoune = { config, pkgs, ... }: {
    config.plugins.kakoune-inc-dec = {
      src = pkgs.fetchFromGitLab {
        owner = "Screwtapello";
        repo = "kakoune-inc-dec";
        rev = "7bfe9c51";
        sha256 = "0f33wqxqbfygxypf348jf1fiscac161wf2xvnh8zwdd3rq5yybl0";
      };
    };
  };
}
