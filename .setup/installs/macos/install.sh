#!/usr/bin/env bash
source $DOTFILES_ROOT/.setup/functions.sh

if test "$(uname)" = "Darwin"
then

info 'setting custom apple script services'

# Apple Scripts - Services
cd ~/Library/Services
for f in $DOTFILES_ROOT/mac-scripts/services/*
do
	info "symlinking $f"
	ln -s "$f"
done

info 'setting macOS defaults'

osascript -e 'tell application "System Preferences" to quit'
sudo -v

# Dock
defaults write com.apple.dock tilesize -int 48 # icon size
defaults write com.apple.dock orientation -string left # position
defaults write com.apple.dock autohide-time-modifier -float 0 # no hide/show delay
defaults write com.apple.dock autohide-delay -float 0 # no hide delay
killall Dock

# Finder
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # list view in Finder
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool TRUE # prevent Photos from opening automatically when devices are plugged in
killall Finder

# Misc.
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
	do shell script "open '$DOTFILES_ROOT/.setup/installs/macos/" & themeName & ".terminal'"
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

fi
