#!/usr/bin/env bash
source $DOTFILES_ROOT/setup/functions.sh

readyn "install hammerspoon config (y/n)? "
if [[ $REPLY =~ ^[Yy]$ ]]
then
	cd "$DOTFILES_ROOT/dots"
	git clone https://github.com/rsefer/hammerspoon-config.git .hammerspoon
	cd .hammerspoon
	cp config.sample.lua config.lua
	success "cloned hammerspoon config repository into $DOTFILES_ROOT"
else
	success 'skipped hammerspoon config install'
fi

defaults write org.hammerspoon.Hammerspoon MJShowDockIconKey -bool FALSE
osascript -e 'tell application "System Events" to make login item at end with properties { path: "/Applications/Hammerspoon.app", hidden: true }' > /dev/null
