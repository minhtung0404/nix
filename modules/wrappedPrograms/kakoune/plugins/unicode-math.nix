{
  flake.wrappers.kakoune = { config, pkgs, ... }: {
    config.plugins.unicode-math = {
      src = pkgs.fetchFromGitHub {
        owner = "natsukagami";
        repo = "kakoune-unicode-math";
        rev = "08dff25da2b86ee0b0777091992bc7fb28c3cb1d";
        # sha256 = lib.fakeSha256;
        sha256 = "sha256-j0L1ARex1i2ma8sGLYwgkfAbh0jWKh/6QGHFaxPXIKc=";
        fetchSubmodules = true;
      };
      activationScript = ''
        require-module unicode-math

        # Bind <c-s> to the menu
        map global insert <c-s> '<a-;>: insert-unicode '
      '';
    };
  };
}
