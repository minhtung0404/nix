{
  # KDE document viewer: PDF default (nixos-mime) and kakoune's TeX forward search
  den.aspects.okular.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.kdePackages.okular ];
    };
}
