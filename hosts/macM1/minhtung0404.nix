{
  pkgs,
  config,
  ...
}:
let
  user = "minhtung0404";
  home = "/Users/${user}/";
in
{
  mtn = {
    hm = {
      enable = true;
      darwin = true;
    };

    username = user;
    programs = {
      my-librewolf.enable = true;
      my-zenbrowser.enable = true;
      my-dock = {
        enable = true;
        apps = [
          "${config.programs.zen-browser.finalPackage}/Applications/Zen Browser (Beta).app/"
          "/System/Applications/Mail.app/"
          "/System/Volumes/Data/Applications/VeraCrypt.app/"
          "${pkgs.obsidian}/Applications/Obsidian.app/"
        ];
      };
    };

    services = {
      my-komga.enable = true;
      my-caddy.enable = true;
    };
  };

  home.username = user;
  home.homeDirectory = home;

  home.packages = with pkgs; [
    texlive.combined.scheme-full
    sops
  ];
}
