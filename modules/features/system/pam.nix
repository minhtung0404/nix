{
  den.aspects.pam.nixos = {
    # PAM
    security.pam.services.login.enableKwallet = true;
    security.pam.services.lightdm.enableKwallet = true;
  };
}
