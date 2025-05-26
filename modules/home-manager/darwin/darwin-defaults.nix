{ pkgs, ... }:
{
  targets.darwin = {
    currentHostDefaults = {
      "com.apple.controlcenter" = {
        BatteryShowPercentage = false;
      };
    };

    defaults = {
      NSGlobalDomain = {
        _HIHideMenuBar = true;
        AppleICUForce24HourTime = true;
        AppleLanguages = [ "en-US" ];
        AppleLocale = "en_FR";
        ApplePressAndHold = false;
        AppleShowAllExtension = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleShowScrollBars = "Automatic";
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = true;
        NSAutomaticDashSubstitutionEnabled = true;
        NSAutomaticPeriodSubstituitionEnable = true;
        NSAutomaticWindowAnimationsEnabled = false;
      };
      "com.apple.finder" = {
        AppleShowAllExtensions = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv";
        FXRemoveOldTrashItems = true;
        NewWindowTarget = "Home";
        QuitMenuItem = true;
        ShowExternalHardDrivesOnDesktop = false;
        ShowPathbar = true;
        ShowRemovableMediaOnDesktop = false;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };
      "com.apple.dock" = {
        autohide = true;
        launchanim = false;
        largesize = 128;
        tilesize = 81;
        magnification = true;
        mru-spaces = false;
        show-recents = false;
      };
      loginwindow.GuestEnabled = false;
      screencapture.location = "~/Documents/screenshot/";

      hitoolbox.AppleFnUsageType = "Change Input Source";

      spaces.spans-displays = false;
    };

    linkApps = {
      enable = true;
      directory = "Applications/Home Manager Apps";
    };
  };
}
