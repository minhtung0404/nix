{
  flake.wrappers.kakoune =
    { config, pkgs, ... }:
    {
      config.plugins.luar = {
        src = pkgs.fetchFromGitHub {
          owner = "gustavo-hms";
          repo = "luar";
          rev = "2f430316f8fc4d35db6c93165e2e77dc9f3d0450";
          sha256 = "sha256-vHn/V3sfzaxaxF8OpA5jPEuPstOVwOiQrogdSGtT6X4=";
        };
        activationScript = ''
          # Enable luar
          require-module luar
          # Use luajit
          set-option global luar_interpreter ${pkgs.luajit}/bin/luajit
        '';
      };
    };
}
