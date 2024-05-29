#!/usr/bin/env bash
source $DOTFILES_ROOT/setup/functions.sh

readyn "install raycast config (y/n)? "
if [[ $REPLY =~ ^[Yy]$ ]]
then
	cd "$DOTFILES_ROOT/dots"
	git clone https://github.com/rsefer/raycast-config.git .raycast
	success "cloned raycast config repository into $DOTFILES_ROOT"
else
	success 'skipped raycast config install'
fi

osascript -e 'tell application "System Events" to make login item at end with properties { path: "/Applications/Raycast.app", hidden: true }' > /dev/null
