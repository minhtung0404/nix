{ lib, stdenv, fish, writeScript, prependRc ? "", appendRc ? "", ... }:
let
  source-pwd = writeScript "source-pwd" ''
    #!/usr/bin/env ${lib.getExe fish}
    ${builtins.readFile ./scripts/source-pwd.fish}
  '';
  rc = ''
    ${prependRc}
    ${builtins.readFile ./kakrc}
    ${appendRc}

    # Source any settings in the current working directory,
    # recursive upwards
    evaluate-commands %sh{
      ${source-pwd}
    }
  '';
in stdenv.mkDerivation {
  name = "mtn-kakoune-themes";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out
    mkdir -p $out/share/kak/
    cp -r ${./colors} $out/share/kak/colors
    cp -r ${./autoload} $out/share/kak/autoload
    cat <<EOF > $out/share/kak/kakrc.local
    ${rc}
    EOF
  '';
}
