{
  # development tooling: git UI, formatters, build tools, environments
  den.aspects.devTools.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        lazygit
        nixfmt
        gnumake
        ## Dev environments / containers
        devenv
        podman
      ];
    };
}
