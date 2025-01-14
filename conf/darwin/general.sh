#!/usr/bin/env bash

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

source "../../bin/util/confirm.sh"

echo "===== General Configurations ====="

confirm "Enable verbose booting, disable darkwake, keep symbols on crash" &&
    sudo nvram boot-args="-v darkwake=0 keepsyms=1 -arm64e_preview_abi"

confirm "Disable auto boot" &&
    sudo nvram AutoBoot="%00"

confirm "Enable TRIM on unsupported SSDs" &&
    sudo nvram EnableTRIM="true"

confirm "Show message on lock screen: \"If you found this computer, please contact XXX. Thanks in advance.\"" &&
    sudo nvram good-samaritan-message="If you found this computer, please contact XXX. Thanks in advance."

confirm "Expand save panel by default" &&
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true &&
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

confirm "Expand print panel by default" &&
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true &&
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

confirm "Disable the “Are you sure you want to open this application?” dialog" &&
    defaults write com.apple.LaunchServices LSQuarantine -bool false

confirm "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window" &&
    sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

confirm "Disable automatic capitalization, smart dashes, automatic period substitution, smart quotes, and auto-correct" &&
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false &&
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false &&
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false &&
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false &&
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

confirm "Disable Gatekeeper" &&
    sudo spctl --master-disable

confirm "Allow short passwords" &&
    sudo pwpolicy -clearaccountpolicies

confirm "Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before" &&
    sudo defaults write /System/Volumes/Data/.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

confirm "Prevent Time Machine from prompting to use new hard drives as backup volume" &&
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

confirm "Use plain text mode for new TextEdit documents and open/save files as UTF-8 in TextEdit" &&
    defaults write com.apple.TextEdit RichText -int 0 &&
    defaults write com.apple.TextEdit PlainTextEncoding -int 4 &&
    defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

confirm "Enable the debug menu in Address Book" &&
    defaults write com.apple.addressbook ABShowDebugMenu -bool true

confirm "Enable the debug menu in Disk Utility" &&
    defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true &&
    defaults write com.apple.DiskUtility advanced-image-options -bool true

confirm "Auto-play videos when opened with QuickTime Player" &&
    defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

# confirm "Avoiding all apps reopening when macOS crashes" &&
#     sudo chown root ~/Library/Preferences/ByHost/com.apple.loginwindow* &&
#     sudo chmod 000 ~/Library/Preferences/ByHost/com.apple.loginwindow*

# https://www.macobserver.com/tips/disable-os-x-login-screen-saver/
# https://www.reddit.com/r/macmini/comments/posw4u/m1_mac_mini_screen_saver_still_randomly_invokes/
confirm "Disable screen saver at the login screen. Useful to resolve screen saver lockup issues when in a VNC session" &&
    sudo defaults write /Library/Preferences/com.apple.screensaver loginWindowIdleTime 0

confirm "Disable quarantine for all files" &&
    defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "That's all for now. You may need to restart the corresponding apps, or even your computer for the changes to take effect."
exit 0
