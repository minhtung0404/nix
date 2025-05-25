{ ... }:
{
  targets.darwin = {
    currentHostDefaults = {
      "com.apple.controlcenter" = {
        BatteryShowPercentage = false;
      };
    };

    defaults = {
      NSGlobalDomain = {
        AppleLanguages = [ "en-US" ];
        AppleLocale = "en_FR";
        ApplePressAndHold = false;
        AppleShowAllExtension = true;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = true;
        NSAutomaticDashSubstitutionEnabled = true;
        NSAutomaticPeriodSubstituitionEnable = true;
      };
    };
  };
}
