#!/usr/bin/env bash

# ~/.macos — https://mths.be/macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Settings" to quit'

# Ask for the administrator password upfront
sudo -v

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
#sudo scutil --set ComputerName "0x6D746873"
#sudo scutil --set HostName "0x6D746873"
#sudo scutil --set LocalHostName "0x6D746873"
#sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"

# Ask to keep changes when closing documents (do not sliently save, which is annoying).
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool true

# Disable wallpaper tinting in windows
defaults write NSGlobalDomain AppleReduceDesktopTinting -bool true

# Show notification previews only when unlocked
defaults write com.apple.ncprefs content_visibility -int 2

# Do not share Focus mode across devices
defaults write com.apple.donotdisturbd disableCloudSync -int 1

# Disable Gatekeeper
sudo spctl --master-disable
sudo defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool NO

# Disable auto boot
sudo nvram AutoBoot="%00"

# Enable verbose booting, disable darkwake, keep symbols on crash, enable arm64e abi. SIP must be disabled before running this." &&
if [[ "$(csrutil status)" =~ "disabled" ]]; then
    sudo nvram boot-args="-v darkwake=0 keepsyms=1 -arm64e_preview_abi"
fi

# Disable screen saver at the login screen. Useful to resolve screen saver lockup issues when in a VNC session

# Disable the over-the-top focus ring animation
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false
sudo defaults write /Library/Preferences/com.apple.screensaver loginWindowIdleTime 0

# Adjust toolbar title rollover delay
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

# Disable smooth scrolling
# (Uncomment if you’re on an older Mac that messes up the animation)
#defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

# Increase window resize speed for Cocoa applications
# defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable Resume system-wide
# defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
# defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the crash reporter
#defaults write com.apple.CrashReporter DialogType -string "none"

# Set Help Viewer windows to non-floating mode
# defaults write com.apple.helpviewer DevMode -bool true

# Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)
# Commented out, as this is known to cause problems in various Adobe apps :(
# See https://github.com/mathiasbynens/dotfiles/issues/237
#echo "0x08000100:0" > ~/.CFUserTextEncoding

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Disable Notification Center and remove the menu bar icon
# launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
#rm -rf ~/Library/Application Support/Dock/desktoppicture.db
#sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
#sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

# Disable AirPlay Receiver to free up ports 5000 and 7000
defaults -currentHost write com.apple.controlcenter AirplayRecieverEnabled -bool false

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: set click to light
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0

# Trackpad: use dragging option - three finger drag
defaults write com.apple.AppleMultitouchTrackpad DragLock -bool false
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerDragGesture -bool true

# Various exported settings
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.fiveFingerPinchSwipeGesture -int 2
defaults -currentHost write NSGlobalDomain com.apple.trackpad.fourFingerHorizSwipeGesture -int 2
defaults -currentHost write NSGlobalDomain com.apple.trackpad.fourFingerPinchSwipeGesture -int 2
defaults -currentHost write NSGlobalDomain com.apple.trackpad.fourFingerVertSwipeGesture -int 2
defaults -currentHost write NSGlobalDomain com.apple.trackpad.momentumScroll -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.pinchGesture -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.rotateGesture -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.scrollBehavior -int 2
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerDragGesture -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerHorizSwipeGesture -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerTapGesture -int 2
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerVertSwipeGesture -int 0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.twoFingerDoubleTapGesture -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture -int 3
defaults -currentHost write NSGlobalDomain com.apple.trackpad.version -int 5

# Trackpad: map bottom right corner to right-click
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Disable “natural” (Lion-style) scrolling
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Increase sound quality for Bluetooth headphones/headsets
# defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
# ^ I think that's outdated. See below.
# https://www.macrumors.com/how-to/enable-aptx-aac-bluetooth-audio-codecs-macos/
defaults write bluetoothaudiod "Enable AptX codec" -bool true

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable Universal Control
# defaults write com.apple.universalcontrol Disable -bool true
# defaults write com.apple.universalcontrol DisableMagicEdges -bool true

# Automatically illuminate built-in MacBook keyboard in low light
# defaults write com.apple.BezelServices kDim -bool true
# Turn off keyboard illumination when computer is not used for 5 minutes
# defaults write com.apple.BezelServices kDimTime -int 300

# Use scroll gesture with the Ctrl (^) modifier key to zoom
# defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
# defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
# defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en-US"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=CNY"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
defaults write NSGlobalDomain AppleTemperatureUnit -string "Celsius"

# Click in the scroll bar to jump to the spot that is clicked
defaults write NSGlobalDomain AppleScrollerPagingBehavior -int 1

# Show language menu in the top right corner of the boot screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
# sudo systemsetup -settimezone "Europe/Brussels" > /dev/null

# Stop iTunes from responding to the keyboard media keys
#launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

###############################################################################
# Energy saving                                                               #
###############################################################################

# Disable standby
sudo pmset -a standby 0

# Disable autopoweroff
sudo pmset -a autopoweroff 0

# Disable ttyskeepawake
sudo pmset -a ttyskeepawake 0

# Disable proximitywake
sudo pmset -a proximitywake 0

# Disable tcpkeepalive
sudo pmset -a tcpkeepalive 0

# Disable powernap
sudo pmset -a powernap 0

# Disable acwake
sudo pmset -a acwake 0

# Disable womp
sudo pmset -a womp 0

# Hibernation mode
# 0: Disable hibernation (speeds up entering sleep mode)
# 3: Copy RAM to disk so the system state can still be restored in case of a
#    power failure.
sudo pmset -a hibernatemode 0

# Do not dim display on battery
sudo pmset -b lessbright 0

# Disk sleep only on battery
sudo pmset -b disksleep 10
sudo pmset -c disksleep 0 # disable on AC

# Display sleep: 10m battery, 20m AC
sudo pmset -b displaysleep 10
sudo pmset -c displaysleep 20

if [ -f /private/var/vm/sleepimage ]; then
    # Remove the sleep image file to save disk space
    sudo rm /private/var/vm/sleepimage 2>/dev/null
    # Create a zero-byte file instead…
    sudo touch /private/var/vm/sleepimage 2>/dev/null
    # …and make sure it can’t be rewritten
    sudo chflags uchg /private/var/vm/sleepimage 2>/dev/null
fi

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
# defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
# defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
# defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
# defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# Show resolution as a list
defaults write com.apple.Displays-Settings.extension showListByDefault -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Open folders in new windows instead of tabs
defaults write com.apple.finder FinderSpawnTab -bool false

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Set Computer as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfCm"
# defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Show icons for hard drives, servers, and removable media on the desktop
# defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
# defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
# defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
# defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
# defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
# defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories (when you drag a file onto a dir and opens the dir)
# defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
# defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
# defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
# defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show item info near icons on the desktop and in other icon views
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
# /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show the ~/Library folder
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Remove Dropbox’s green checkmark icons in Finder
# file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
# [ -e "${file}" ] && mv -f "${file}" "${file}.bak"

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

# Empty bin items after 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Do not use iPhone widgets
defaults write com.apple.chronod remoteWidgetsEnabled -bool false
defaults write com.apple.chronod effectiveRemoteWidgetsEnabled -bool false

# Use monochrome widgets
defaults write com.apple.widgets widgetAppearance -int 0

# Clock in menu bar
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
defaults write com.apple.menuextra.clock ShowAMPM -bool true
defaults write com.apple.menuextra.clock ShowDate -int 0
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowSeconds -bool false

# Menu bar, various items
defaults write com.apple.controlcenter "NSStatusItem Visible AudioVideoModule" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible BentoBox" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible Clock" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible Display" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible FaceTime" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible FocusModes" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool true

defaults -currentHost write com.apple.controlcenter "Bluetooth" -int 2 # Show
defaults -currentHost write com.apple.controlcenter "KeyboardBrightness" -int 1 # In Control Center
defaults -currentHost write com.apple.controlcenter "NowPlaying" -int 8 # Never visible
defaults -currentHost write com.apple.controlcenter "Sound" -int 18 # Always Show
defaults -currentHost write com.apple.controlcenter "VoiceControl" -int 8
defaults -currentHost write com.apple.controlcenter "Battery" -int 8 # Never visible. I use iStat Menus so I don't need this.

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Set the icon size of Dock items to 28 pixels
defaults write com.apple.dock tilesize -int 28

# Put Dock on left
defaults write com.apple.dock orientation -string left

# Enable Expose
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

# Change minimize/maximize window effect
# defaults write com.apple.dock mineffect -string "scale"

# Do not minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool false

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array

# Show only open applications in the Dock
#defaults write com.apple.dock static-only -bool true

# Don’t animate opening applications from the Dock
# defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
# defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Disable Dashboard
# defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
# defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Reduce the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.25

# Automatically hide and show the Dock
# defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Don’t show recent applications in Dock
# defaults write com.apple.dock show-recents -bool false

# Disable the Launchpad gesture (pinch with thumb and three fingers)
#defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

# Reset Launchpad, but keep the desktop wallpaper intact
# find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

# Add iOS & Watch Simulator to Launchpad
# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

# Add a spacer to the left side of the Dock (where the applications are)
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# Top left screen corner → Mission Control
# defaults write com.apple.dock wvous-tl-corner -int 2
# defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
# defaults write com.apple.dock wvous-tr-corner -int 4
# defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
# defaults write com.apple.dock wvous-bl-corner -int 5
# defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Window Management                                                           #
###############################################################################

# Don't do anything when clicking the wallpaper
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Remove margins from tiled windows
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false

# Do not show desktop icons
defaults write com.apple.WindowManager HideDesktop -bool true
defaults write com.apple.WindowManager StandardHideDesktopIcons -bool true

# StageManagerHideWidgets
defaults write com.apple.WindowManager StageManagerHideWidgets -bool true


###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Privacy: don’t send search queries to Apple
# defaults write com.apple.Safari UniversalSearchEnabled -bool false
# defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Press Tab to highlight each item on a web page
# defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
# defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Allow hitting the Backspace key to go to the previous page in history
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Hide Safari’s bookmarks bar by default
# defaults write com.apple.Safari ShowFavoritesBar -bool false

# Hide Safari’s sidebar in Top Sites
# defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Disable Safari’s thumbnail cache for History and Top Sites
# defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
# defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
# defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari DeveloperMenuVisibility -bool true
defaults write com.apple.Safari.SandboxBroker ShowDevelopMenu -bool true
defaults write com.apple.Safari WebKitPreferences.developerExtrasEnabled -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Enable continuous spellchecking
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
# Disable auto-correct
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable AutoFill
# defaults write com.apple.Safari AutoFillFromAddressBook -bool false
# defaults write com.apple.Safari AutoFillPasswords -bool false
# defaults write com.apple.Safari AutoFillCreditCardData -bool false
# defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Disable plug-ins
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

# Disable Java
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

# Enable extensions
defaults write com.apple.Safari ExtensionsEnabled -bool true

# Disable Automatic Strong Passwords
defaults write com.apple.Safari EnableAutomaticStrongPasswords -bool false

# Block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Disable auto-playing video
#defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
#defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
#defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
#defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

defaults write com.apple.Safari MobileDeviceRemoteXPCEnabled -bool true

defaults write com.apple.Safari SearchProviderShortName -string "Google"

defaults write com.apple.Safari ShowFavorites -bool false

defaults write com.apple.Safari ShowFrequentlyVisitedSites -bool false

defaults write com.apple.Safari ShowSidebarInNewWindows -bool false
defaults write com.apple.Safari ShowSidebarInTopSites -bool false
defaults write com.apple.Safari ShowSiriSuggestionsPreference -bool false
defaults write com.apple.Safari ShowTabGroupFavoritesPreferenceKey -bool false

# Update extensions automatically
# defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

# Disable send and reply animations in Mail.app
# defaults write com.apple.mail DisableReplyAnimations -bool true
# defaults write com.apple.mail DisableSendAnimations -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
# defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
# defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

# Display emails in threaded mode, sorted by date (oldest at the top)
# defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
# defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
# defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

# Disable inline attachments (just show the icons)
# defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Disable automatic spell checking
# defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Hide Spotlight menubar icon

defaults -currentHost write com.apple.Spotlight MenuItemHidden -bool true

# Hide Spotlight tray-icon (and subsequent helper)
#sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
# sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Change indexing order and disable some search results
# Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
# 	MENU_DEFINITION
# 	MENU_CONVERSION
# 	MENU_EXPRESSION
# 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
# 	MENU_WEBSEARCH             (send search queries to Apple)
# 	MENU_OTHER
# defaults write com.apple.spotlight orderedItems -array \
# 	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
# 	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
# 	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
# 	'{"enabled" = 1;"name" = "PDF";}' \
# 	'{"enabled" = 1;"name" = "FONTS";}' \
# 	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
# 	'{"enabled" = 0;"name" = "MESSAGES";}' \
# 	'{"enabled" = 0;"name" = "CONTACT";}' \
# 	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
# 	'{"enabled" = 0;"name" = "IMAGES";}' \
# 	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
# 	'{"enabled" = 0;"name" = "MUSIC";}' \
# 	'{"enabled" = 0;"name" = "MOVIES";}' \
# 	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
# 	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
# 	'{"enabled" = 0;"name" = "SOURCE";}' \
# 	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
# 	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
# 	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
# 	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
# 	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
# 	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
# # Load new settings before rebuilding the index
# killall mds > /dev/null 2>&1
# # Make sure indexing is enabled for the main volume
# sudo mdutil -i on / > /dev/null
# # Rebuild the index from scratch
# sudo mdutil -E / > /dev/null

# No Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false

# No Help Apple Improve Search
defaults write com.apple.assistant.support "Search Queries Data Sharing Status" -int 2

###############################################################################
# Terminal                                                                    #
###############################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Enable “focus follows mouse” for Terminal.app and all X11 apps
# i.e. hover over a window and start typing in it without clicking first
#defaults write com.apple.terminal FocusFollowsMouse -bool true
#defaults write org.x.X11 wm_ffm -bool true

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Disable the annoying line marks
defaults write com.apple.Terminal ShowLineMarks -int 0

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Show network speed instead of PPS
defaults write com.apple.ActivityMonitor NetworkGraphType -int 1

# Show IO rate instead of IOPS
defaults write com.apple.ActivityMonitor DiskGraphType -int 1

###############################################################################
# Address Book, Dashboard, TextEdit, and Disk Utility                         #
###############################################################################

# Enable the debug menu in Address Book
defaults write com.apple.addressbook ABShowDebugMenu -bool true

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

# Show all devices in the Disk Utility sidebar
defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true

# Show APFS snapshots
defaults write com.apple.DiskUtility WorkspaceShowAPFSSnapshots -bool true

# Auto-play videos when opened with QuickTime Player
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Disable In-App Ratings and Reviews
defaults write com.apple.appstore InAppReviewEnabled -bool false

# Disable Video Autoplay
defaults write com.apple.appstore UserSetAutoPlayVideoSetting -bool true
defaults write com.apple.appstore AutoPlayVideoSetting -string off

# Disable automatic download of in-app content
defaults write com.apple.appstored BackgroundAssetDownloadsEnabled -bool false

###############################################################################
# Mac Updates                                                                 #
###############################################################################

# Disable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 0

# Do not install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 0

# No automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 0

# Turn off app auto-update
defaults write com.apple.commerce AutoUpdate -bool false

# Do not allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool false

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Messages                                                                    #
###############################################################################

# Disable smart quotes as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable continuous spell checking
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
# END                                                                         #
###############################################################################

echo "There are a few more settings that I am not able to change. Go ahead and change them manually:"
echo "  - Wi-Fi -> Ask to join networks / Ask to join hotspots -> OFF (annoying)"
echo "  - General -> Software Update -> Automatic Updates -> i -> Turn Everything OFF"
echo "  - Displays -> Advanced -> Show resolution as list -> ON"
echo "  - Soptlight -> Only keep Applications, deselect everything (we will use Alfred)"
echo "  - Notifications -> Allow notifications when the display is sleeping -> OFF"
echo "  - Notifications -> Allow notifications when the screen is locked -> OFF (avoid constantly waking screen)"
echo "  - Notifications -> Allow notifications when mirroring or sharing the display -> OFF"

echo "Completed. It's expected that you may find System Settings not behaving like normal. Reboot your Mac."
