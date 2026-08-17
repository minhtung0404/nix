{
  flake.wrappers.kakoune = { config, pkgs, ... }: {
    config.plugins.kakoune-mirror = {
      src =
        pkgs.fetchFromGitHub {
          owner = "Delapouite";
          repo = "kakoune-mirror";
          rev = "5710635f440bcca914d55ff2ec1bfcba9efe0f15";
          sha256 = "sha256-uslx4zZhvjUylrPWvTOugsKYKKpF0EEz1drc1Ckrpjk=";
        }
        + "/mirror.kak";
      wrapAsModule = true;
      activationScript = ''
        require-module kakoune-mirror

        # Bind <a-w> to kakoune-mirror
        map global normal <a-w> ': enter-user-mode -lock mirror<ret>'
      '';
    };
  };
}
