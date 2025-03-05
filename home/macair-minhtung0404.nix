{ ... }:

{
  imports = [
    ./common.nix
    ../modules/terminals/kitty
    ../modules/misc/ssh
    ../modules/editors/nvim
  ];
}
