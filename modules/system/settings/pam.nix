{
  flake.modules.nixos.pam = {
    # PAM
    security.pam.services.login.enableKwallet = true;
    security.pam.services.lightdm.enableKwallet = true;
    security.pam.services.swaylock = { };
  };
}
