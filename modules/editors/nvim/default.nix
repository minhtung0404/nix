{ ... }: {
  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
