{ den, ... }:
{
  # import all essential nix-tools which are used in all hosts

  den.aspects.systemDefault = {
    includes = [
      den.aspects.systemMinimal
      den.aspects.homebrew
    ];
  };
}
