{
  den.aspects.intellij.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.jetbrains.idea ];
    };
}
