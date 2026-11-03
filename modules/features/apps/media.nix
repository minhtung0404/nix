{
  den.aspects.media.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vlc
        deluge # torrent client
      ];
    };
}
