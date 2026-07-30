{
  flake.modules.homeManager.tex = { pkgs, ... }: {
    home.packages = with pkgs; [
      texliveFull
      bibtool
    ];
  };
}
