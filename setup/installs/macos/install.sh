#!/usr/bin/env bash
source $DOTFILES_ROOT/setup/functions.sh

if test "$(uname)" = "Darwin"
then

info 'setting custom apple script services'

# Apple Scripts - Services
for f in $DOTFILES_ROOT/mac-scripts/services/*
do
	dst="$HOME/Library/Services/$(basename "$f")"
	link_file "$f" "$dst"
done

info 'setting macOS defaults'

osascript -e 'tell application "System Preferences" to quit'
sudo -v

# Dock
defaults write com.apple.dock tilesize -int 30 # icon size
defaults write com.apple.dock orientation -string right # position
defaults write com.apple.dock autohide-time-modifier -float 0 # no hide/show delay
defaults write com.apple.dock autohide-delay -float 0 # no hide delay
defaults write com.apple.dock show-process-indicators -bool true # show indicators for open applications
defaults write com.apple.sock show-recents -bool false # don't show recently used applications

dockutil --no-restart --add "/Applications/System Preferences.app"
dockutil --no-restart --add "/Applications/Reminders.app"
dockutil --no-restart --add "/Applications/Messages.app"
dockutil --no-restart --add "/Applications/Home.app"
dockutil --no-restart --add "/Applications/Home Assistant.app"
dockutil --no-restart --add "/Applications/Spotify.app"
dockutil --no-restart --add "/Applications/Photos.app"
dockutil --no-restart --add "/Applications/Tweetbot.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Adobe Photoshop 2021/Adobe Photoshop 2021.app"
dockutil --no-restart --add "/Applications/Adobe Illustrator 2021/Adobe Illustrator 2021.app"
dockutil --no-restart --add "/Applications/Local.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/Coda 2.app"
dockutil --no-restart --add "/Applications/GitHub Desktop.app"
dockutil --no-restart --add "/Applications/Basecamp.app"
dockutil --no-restart --add "/Applications/TextEdit.app"
dockutil --no-restart --add "/Applications/Utilities/Terminal.app"
dockutil --no-restart --add "~/Downloads"

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

# localhost SSL
COMPANYNAME="Sefer Design Company LLC"
COMPANYCOUNTRY="US"
COMPANYSTATE="IL"
COMMONNAME="localhost"

info "creating $COMMONNAME ssl"

mkdir $LOCALHOSTSSLDIR
cd $LOCALHOSTSSLDIR

openssl genrsa -out ca.key 2048
openssl req -new -x509 -days 3650 -key ca.key -subj "/C=$COMPANYCOUNTRY/ST=$COMPANYSTATE/O=$COMPANYNAME/CN=$COMPANYNAME Root CA" -out ca.crt
openssl req -newkey rsa:2048 -nodes -keyout server.key -subj "/C=$COMPANYCOUNTRY/ST=$COMPANYSTATE/O=$COMPANYNAME/CN=$COMMONNAME" -out server.csr
openssl x509 -req -extfile <(printf "subjectAltName=DNS:$COMMONNAME") -days 3650 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt

sudo security add-trusted-cert -d -r trustAsRoot -k /Library/Keychains/System.keychain $LOCALHOSTSSLDIR/server.crt

fi
