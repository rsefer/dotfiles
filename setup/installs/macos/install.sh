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
defaults write com.apple.dock orientation -string left # position
defaults write com.apple.dock autohide-time-modifier -float 0 # no hide/show delay
defaults write com.apple.dock autohide-delay -float 0 # no hide delay
defaults write com.apple.dock show-process-indicators -bool true # show indicators for open applications
killall Dock

# Finder
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME" # open new windows in home directory
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

# # Install SF Mono font
# cp -R /Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/

# Terminal - adapted from https://github.com/ymendel/dotfiles/blob/master/osx/terminal.defaults
TERMINAL_THEME_NAME="Tomorrow Night RSefer"
open $DOTFILES_ROOT/setup/installs/macos/$TERMINAL_THEME_NAME.terminal
sleep 1
defaults write com.apple.Terminal "Default Window Settings" -string "$TERMINAL_THEME_NAME"
defaults write com.apple.Terminal "Startup Window Settings" -string "$TERMINAL_THEME_NAME"
defaults write com.apple.terminal StringEncodings -array 4
defaults write com.apple.terminal ShowLineMarks -int 0

# localhost SSL
LOCALHOSTSSLDIR=$HOME/.localhost-ssl
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
