{ den, ... }:
{
  # import all essential nix-tools which are used in all hosts

  den.aspects.system-default = {
    includes = [
      den.aspects.system-minimal
      den.aspects.homebrew
    ];
  };
}
