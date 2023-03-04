#!/usr/bin/env bash

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

source "../../bin/util/confirm.sh"

echo "===== Safari Configurations ====="

confirm "Show the full URL in the address bar" &&
    defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

confirm "Prevent Safari from opening ‘safe’ files automatically after downloading" &&
    defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

confirm "Enable Safari’s debug menu" &&
    defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

confirm "Enable the Develop menu and the Web Inspector in Safari" &&
    defaults write com.apple.Safari IncludeDevelopMenu -bool true &&
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true &&
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

confirm "Add a context menu item for showing the Web Inspector in web views" &&
    defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Enable continuous spellchecking
# defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
# Disable auto-correct
# defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable AutoFill
# defaults write com.apple.Safari AutoFillFromAddressBook -bool false
# defaults write com.apple.Safari AutoFillPasswords -bool false
# defaults write com.apple.Safari AutoFillCreditCardData -bool false
# defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

confirm "Warn about fraudulent websites" &&
    defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

confirm "Enable “Do Not Track”" &&
    defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

echo "That's all for now. You may need to restart the corresponding apps, or even your computer for the changes to take effect."
exit 0
