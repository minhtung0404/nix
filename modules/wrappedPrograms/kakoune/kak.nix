{
  flake.wrappers.kakoune =
    {
      config,
      pkgs,
      wlib,
      lib,
      ...
    }:
    {
      imports = [ wlib.modules.default ];

      config = {
        package = pkgs.kakoune-unwrapped;

        env = {
          KAKOUNE_RUNTIME = "${placeholder "out"}/share/kak";
        };

        buildCommand.copyAutoloadAndColors = {
          after = [ "symlinkScript" ];
          data = ''
            mkdir -p ${placeholder config.outputName}/share/kak/{autoload,colors}

            for file in ${./autoload}/*; do
              ln -s "$file" ${placeholder config.outputName}/share/kak/autoload/
            done

            for file in ${./colors}/*; do
              ln -s "$file" ${placeholder config.outputName}/share/kak/colors/
            done
          '';
        };
      };
    };
}
