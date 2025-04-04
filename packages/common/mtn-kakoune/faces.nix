{
  writeTextDir,
  lib,
  ...
}:
let
  mkFacesScript =
    name: faces:
    writeTextDir "share/kak/autoload/${name}/faces.kak" ''
      hook global KakBegin .* %{
      ${lib.concatStringsSep "\n" (
        builtins.attrValues (builtins.mapAttrs (name: face: "  face global ${name} \"${face}\"") faces)
      )}
      }
    '';
  faces = {
    # Default = "%opt{text},%opt{base}";
    # BufferPadding = "%opt{base},%opt{base}";
    # MenuForeground = "%opt{blue},white+bF";
    # MenuBackground = "%opt{sky},white+F";
    # Information = "%opt{sky},white";
    # Markdown help color scheme
    InfoDefault = "Information";
    InfoBlock = "@block";
    InfoBlockQuote = "+i@block";
    InfoBullet = "@bullet";
    InfoHeader = "@header";
    InfoLink = "@link";
    InfoLinkMono = "+b@mono";
    InfoMono = "@mono";
    InfoRule = "+b@Information";
    InfoDiagnosticError = "@DiagnosticError";
    InfoDiagnosticHint = "@DiagnosticHint";
    InfoDiagnosticInformation = "@Information";
    InfoDiagnosticWarning = "@DiagnosticWarning";
    # Extra faces
    macro = "+u@function";
    method = "@function";
    format_specifier = "+i@string";
    mutable_variable = "+i@variable";
    class = "+b@variable";
  };
in
mkFacesScript "default-faces" faces
