{ den, self, ... }:
{
  # import all essential nix-tools which are used in all hosts

  den.aspects.system-default = {
    includes = [
      den.aspects.system-minimal
      den.aspects.homebrew
    ];

    # mtn.constants is still a flake.modules.generic module (to be replaced by
    # den's host/user context)
    # NOTE: must be a function; a plain `os.imports = [ … ]` attrset causes an
    # infinite recursion on darwin hosts
    os = { ... }: {
      imports = [ self.modules.generic.constants ];
    };

    # homeManager on a host-included aspect is dropped by den; to-users routes it
    # to every user of the host
    provides.to-users.homeManager.imports = [ self.modules.generic.constants ];
  };
}
