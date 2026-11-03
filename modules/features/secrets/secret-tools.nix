{
  # secrets & passwords from the command line
  den.aspects.secretTools.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        sops
        bitwarden-cli
      ];
    };
}
