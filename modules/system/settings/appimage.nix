{
  flake.modules.nixos.appimage = {
    # AppImages should run
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

  };
}
