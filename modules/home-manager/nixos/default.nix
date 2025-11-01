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
  mtn.programs.my-niri.enable = true;

  services.caffeine.enable = true;
}
