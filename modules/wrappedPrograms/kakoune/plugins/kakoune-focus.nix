{
  flake.wrappers.kakoune = { config, pkgs, ... }: {
    config.plugins.kakoune-focus = {
      src = pkgs.fetchFromGitHub {
        owner = "caksoylar";
        repo = "kakoune-focus";
        rev = "949c0557cd4c476822acfa026ca3c50f3d38a3c0";
        sha256 = "sha256-ZV7jlLJQyL420YG++iC9rq1SMjo3WO5hR9KVvJNUiCs=";
      };
      activationScript = ''
        map global user <space> ': focus-toggle<ret>' -docstring "toggle selections focus"
      '';
    };
  };
}
