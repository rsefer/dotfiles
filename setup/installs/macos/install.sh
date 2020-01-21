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
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool TRUE

# # Install SF Mono font
# cp -R /Applications/Utilities/Terminal.app/Contents/Resources/Fonts/. /Library/Fonts/

# Terminal
defaults write com.apple.terminal StringEncodings -array 4
defaults write com.apple.terminal ShowLineMarks -int 0

# set theme - adapted from https://github.com/mathiasbynens/dotfiles/blob/299b7dc6db8715a8b306267c14f62673286a19f3/.macos#L626
osascript <<EOD
tell application "Terminal"
	local allOpenedWindows
	local initialOpenedWindows
	local windowID
	set themeName to "Tomorrow Night RSefer"
	set initialOpenedWindows to id of every window
	do shell script "open '$DOTFILES_ROOT/setup/installs/macos/" & themeName & ".terminal'"
	delay 1
	set default settings to settings set themeName
	set allOpenedWindows to id of every window
	repeat with windowID in allOpenedWindows
		if initialOpenedWindows does not contain windowID then
			close (every window whose id is windowID)
		else
			set current settings of tabs of (every window whose id is windowID) to settings set themeName
		end if
	end repeat
end tell
EOD

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
