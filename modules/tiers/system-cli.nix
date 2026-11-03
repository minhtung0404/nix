{ den, ... }:
{
  # import all essential nix-tools which are used in all hosts
  den.aspects.system-cli = {
    includes = with den.aspects; [
      system-default

      fish
      cliTools
      sops
      edns
    ];

    # default editor, system-wide on nixos and darwin (fish narrows it to the current
    # kakoune session, see features/editor/kakoune.nix)
    os.environment.variables = {
      EDITOR = "kak";
      VISUAL = "kak";
    };

    # homeManager on a host-included aspect is dropped by den; to-users routes it
    # to every user of the host
    provides.to-users.homeManager.home.shell.enableFishIntegration = true;
  };
}
