{ den, ... }:
{
  # import all essential nix-tools which are used in all hosts
  den.aspects.system-cli = {
    includes = with den.aspects; [
      system-default
      home-manager

      fish
      cliTools
      sops
      edns
    ];

    # homeManager on a host-included aspect is dropped by den; to-users routes it
    # to every user of the host
    provides.to-users.homeManager = {
      home.sessionVariables = {
        EDITOR = "kak";
      };

      home.shell.enableFishIntegration = true;
    };
  };
}
