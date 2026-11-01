{
  # KDE file manager without the rest of Plasma
  den.aspects.dolphin.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs.kdePackages; [
        dolphin
        kio-extras # thumbnails, sftp/smb/… locations
        kio-fuse # open KIO locations from non-KDE apps
        ffmpegthumbs # video thumbnails
      ];
    };
}
