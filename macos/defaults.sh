#!/bin/bash
#
# The macOS preferences this setup expects.
# Every line is a deviation from the factory defaults; anything the factory
# already gets right is left out, so this file stays a diff rather than a dump.
#
# Deliberately not wired into install.conf.yaml — that one is a symlink sync
# meant to be re-run any time, and shouldn't mutate system state or kill Finder.
#
#   ./macos/defaults.sh

set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
    echo "$0: macOS only" >&2
    exit 1
fi

# Only the Spotlight index needs root; grab the credential up front so the
# password prompt doesn't land halfway through the run
sudo -v

################################################################################
# Keyboard
################################################################################

# Holding a key pops up the accent menu by default; turn it off and the key
# repeats the way it does on every other system
defaults write -g ApplePressAndHoldEnabled -bool false

################################################################################
# Text substitution
################################################################################

# These three turn " into curly quotes, -- into an em dash and ... into an
# ellipsis, which is nothing but a trap in code and commit messages
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticEllipsisSubstitutionEnabled -bool false

# Sentence-start capitalisation mangles lowercase identifiers
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# Spelling correction, and the double-space-inserts-a-period shortcut
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

################################################################################
# Trackpad
################################################################################

# Tap to click
# The built-in and the external Magic Trackpad are separate domains behind the
# one switch in System Settings, so both have to be written
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# The two above only make the settings pane show it as on; the per-host value
# is what the current login session actually reads
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1

################################################################################
# Finder
################################################################################

defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Extensions of "known" types are hidden by default, .txt among them
defaults write -g AppleShowAllExtensions -bool true

# Column view
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Search defaults to the whole Mac; the current folder is what's wanted almost
# every time
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# New windows open at home rather than Recents
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Column view display options, written as one block; ArrangeBy's pAdd is
# "Date Added".
# Spelled as an XML plist rather than defaults' { } literal: the latter writes
# every value as a string, and Finder then can't read the booleans and integers
defaults write com.apple.finder StandardViewOptions '<dict>
    <key>ColumnViewOptions</key>
    <dict>
        <key>ArrangeBy</key><string>pAdd</string>
        <key>SharedArrangeBy</key><string>kipl</string>
        <key>ColumnShowFolderArrow</key><true/>
        <key>ColumnShowIcons</key><true/>
        <key>ColumnWidth</key><integer>245</integer>
        <key>FontSize</key><integer>13</integer>
        <key>PreviewDisclosureState</key><true/>
        <key>ShowIconThumbnails</key><true/>
        <key>ShowPreview</key><true/>
    </dict>
</dict>'

# ~/Library ships with the hidden flag set, which keeps it out of Finder
chflags nohidden "${HOME}/Library"

################################################################################
# Spotlight
################################################################################

# Cmd-Space goes to Raycast; the Opt-Cmd-Space Finder search window goes too.
# 64 and 65 are the fixed symbolichotkeys ids for those two.
# The three parameters are key character, key code and modifier mask — they
# have to be carried over verbatim, since writing enabled alone wipes the
# shortcut definition
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict>
    <key>enabled</key><false/>
    <key>value</key>
    <dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array><integer>32</integer><integer>49</integer><integer>1048576</integer></array>
    </dict>
</dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 '<dict>
    <key>enabled</key><false/>
    <key>value</key>
    <dict>
        <key>type</key><string>standard</string>
        <key>parameters</key>
        <array><integer>32</integer><integer>49</integer><integer>1572864</integer></array>
    </dict>
</dict>'

# Stop the index itself, and the background mds scanning with it.
# The cost is Finder's "This Mac" search and Raycast's Search Files, both of
# which read this index
sudo mdutil -a -i off

################################################################################
# Disks
################################################################################

# Network shares and USB sticks are other people's too — don't litter .DS_Store
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

################################################################################
# Dock
################################################################################

defaults write com.apple.dock autohide -bool true

# Don't pile recently used apps onto the end
defaults write com.apple.dock show-recents -bool false

################################################################################

for app in Finder Dock; do
    killall "$app" > /dev/null 2>&1 || true
done

echo "Done. The keyboard, text and hotkey settings apply on the next login."
