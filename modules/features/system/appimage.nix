{
  den.aspects.appimage.nixos = {
    # AppImages should run
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

  };
}
