#!/usr/bin/env bash
source $DOTFILES_ROOT/setup/functions.sh

if test "$(uname)" = "Darwin"
then

info 'setting macOS defaults'

osascript -e 'tell application "System Preferences" to quit'
sudo -v

# Dock
defaults write com.apple.dock tilesize -int 25 # icon size
defaults write com.apple.dock orientation -string right # position
defaults write com.apple.dock autohide-time-modifier -float 0 # no hide/show delay
defaults write com.apple.dock autohide-delay -float 0 # no hide delay
defaults write com.apple.dock show-process-indicators -bool true # show indicators for open applications
defaults write com.apple.sock show-recents -bool false # don't show recently used applications

APPS=(
	"System Preferences"
	"1Password"
	"Fantastical"
	"Mimestream"
	"Messages"
	"Home"
	"Home Assistant"
	"Spotify"
	"Photos"
	"Twitter"
	"Arc"
	"Safari"
	"Adobe Photoshop 2024/Adobe Photoshop 2024"
	"Adobe Illustrator 2024/Adobe Illustrator 2024"
	"Figma"
	"Visual Studio Code"
	"GitHub Desktop"
	"Local"
	"iTerm"
	"Obsidian"
)
for APP in "${APPS[@]}"; do
  echo "dockutil --no-restart --add \"/Applications/$APP.app\""
done
echo "dockutil --no-restart --add \"~/Downloads\""

killall Dock

# Finder
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # list view in Finder
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool TRUE # prevent Photos from opening automatically when devices are plugged in
killall Finder

# Misc.
defaults write com.apple.TextEdit.plist RichText -int 0 # TextEdit default format plain text
defaults write com.apple.TextEdit.plist NSFixedPitchFontSize -string 18 # TextEdit default text size
defaults write com.apple.finder CreateDesktop false # hide all desktop icons
defaults write com.apple.LaunchServices LSQuarantine -bool FALSE # disable quarantine dialog
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool FALSE # disable smart dashes
defaults write NSGlobalDomain com.apple.sound.beep.feedback -bool false # disable feedback sound when changing volume
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool TRUE
defaults write com.google.Chrome ExternalProtocolDialogShowAlwaysOpenCheckbox -bool true # disable "open this link in [application]" permission dialog
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false # save to file system by default, not iCloud
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40 # Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.screenscapture location ~/Downloads # screen capture location
defaults write -g AppleFontSmoothing -int 0 # Disable font smoothing
defaults write com.apple.dt.Xcode XcodeCloudUpsellPromptEnabled -bool false # disable XCode ad prompts

sudo systemsetup -setrestartfreeze on # restart on freeze

# # Install SF Mono font
# cp -R /Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/

# Terminal - adapted from https://github.com/ymendel/dotfiles/blob/master/osx/terminal.defaults
TERMINAL_THEME_NAME="Tomorrow Night RSefer"
open "$DOTFILES_ROOT/setup/installs/macos/$TERMINAL_THEME_NAME.terminal"
sleep 1
defaults write com.apple.Terminal "Default Window Settings" -string "$TERMINAL_THEME_NAME"
defaults write com.apple.Terminal "Startup Window Settings" -string "$TERMINAL_THEME_NAME"
defaults write com.apple.terminal StringEncodings -array 4
defaults write com.apple.terminal ShowLineMarks -int 0

# iTerm2
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$DOTFILES_ROOT/setup/installs/macos/iterm"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# 1Password symlink
mkdir -p ~/.1password && ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock

# localhost SSL
info "creating local ssl"

mkdir $LOCALHOSTSSLDIR
cd $LOCALHOSTSSLDIR

mkcert -install -cert-file cert.pem -key-file key.pem localhost 127.0.0.1 ::1
# mkcert -install -cert-file cert.pem -key-file key.pem otherdomain.local yetanotherdomain.local localhost 127.0.0.1 ::1

fi
