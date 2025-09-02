{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*.polytechnique.fr" = {
        user = "tung.nguyen";
      };
      "telecom-sud" = {
        hostname = "ssh.imtbs-tsp.eu";
        user = "mnguyen1";
      };
      "b313-* 3a401-*" = {
        proxyJump = "telecom-sud";
        user = "mnguyen1";
      };

      "noname" = {
        forwardAgent = true;
        proxyJump = "mnguyen1@157.159.110.170";
        identityFile = "~/.ssh/id_rsa";
        hostname = "192.168.1.110";
        port = 2222;
        user = "mnguyen1";

        localForwards = [
          {
            bind.address = "127.0.0.1";
            bind.port = 9999;
            host.port = 9999;
            host.address = "localhost";
          }
        ];
      };

      "bran" = {
        forwardAgent = true;
        proxyCommand = "ssh mnguyen1@157.159.110.170 -W %h:%p -o \"StrictHostKeyChecking no\"";
        user = "mnguyen1";
        identityFile = "~/.ssh/id_rsa";
      };

      "tp-*" = {
        hostname = "%h";
        user = "mnguyen-23";
      };
    };
  };
}
