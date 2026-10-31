{
  # not included by any user yet; a user aspect includes it to get the secret
  # on every host it lives on
  den.aspects.overleaf =
    { user, ... }:
    {
      provides.to-hosts.os.sops.secrets."overleaf" = {
        owner = user.userName;
        sopsFile = ./overleaf.yaml;
      };
    };
}
