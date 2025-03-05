{ ... }: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*.polytechnique.fr" = { user = "tung.nguyen"; };
      "telecom-sud" = {
        hostname = "ssh.imtbs-tsp.eu";
        user = "mnguyen1";
      };
      "b313-* 3a401-*" = {
        proxyJump = "ssh.imtbs-tsp.eu";
        user = "mnguyen1";
      };

      "noname" = {
        proxyJump = "mnguyen1@157.159.110.170";
        proxyCommand = ''
          ssh mnguyen1@ssh3.imtbs-tsp.eu -W %h:%p -o "StrictHostKeyChecking no"'';
        identityFile = "~/.ssh.id_rsa";
        hostname = "192.168.1.110";
        port = 2222;
        user = "mnguyen1";
      };
      "tp-*" = {
        hostname = "%h";
        user = "mnguyen-23";
      };
    };
    forwardAgent = true;
    extraConfig = ''
      ForwardX11 yes
      ForwardX11Trusted yes
    '';
  };
}
