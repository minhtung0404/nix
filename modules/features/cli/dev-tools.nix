{
  # development tooling: git UI, formatters, build tools, environments, AI
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
        ## AI
        claude-code
      ];
    };
}
