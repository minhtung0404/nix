{
  ...
}:
{
  imports = [
    ./graphical
    ./programs
  ];

  programs.fish.functions = {
    rebuild = {
      body = ''
        sudo nixos-rebuild switch --flake /etc/nixos
      '';
      wraps = "nixos-rebuild";
    };
  };
  mtn.programs.my-kitty.mod = "alt+shift";

  services.caffeine.enable = true;
}
