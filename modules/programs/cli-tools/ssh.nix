{
  flake.modules.homeManager.ssh =
    { ... }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
          "*.polytechnique.fr" = {
            User = "tung.nguyen";
          };
          "telecom-sud" = {
            HostName = "ssh.imtbs-tsp.eu";
            User = "mnguyen1";
          };
          "b313-* 3a401-*" = {
            ProxyJump = "telecom-sud";
            User = "mnguyen1";
          };

          "noname" = {
            ForwardAgent = true;
            ProxyJump = "mnguyen1@157.159.110.170";
            IdentityFile = "~/.ssh/id_rsa";
            Hostname = "192.168.1.110";
            Port = 2222;
            User = "mnguyen1";

            LocalForward = [
              {
                bind.address = "127.0.0.1";
                bind.port = 9999;
                host.port = 9999;
                host.address = "localhost";
              }
            ];
          };

          "bran" = {
            ForwardAgent = true;
            ProxyCommand = "ssh mnguyen1@157.159.110.170 -W %h:%p -o \"StrictHostKeyChecking no\"";
            User = "mnguyen1";
            IdentityFile = "~/.ssh/id_rsa";
          };

          "tp-*" = {
            Hostname = "%h";
            User = "mnguyen-23";
          };
        };
      };
    };
}
