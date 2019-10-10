#!/usr/bin/env bash
source $DOTFILES_ROOT/.setup/functions.sh

user "install hammerspoon config? Y/n"
read -n 1 action
case "$action" in
  y )
    install=true;;
  n )
    install=false;;
  * )
    install=true;;
esac
if [ "$install" == "true" ]
then
	cd "$DOTFILES_ROOT"
	git clone git@github.com:rsefer/hammerspoon-config.git hammerspoon.symlink
	cd hammerspoon.symlink
	cp config.sample.lua config.lua
	success "cloned hammerspoon config repository into $DOTFILES_ROOT"
else
	success 'skipped hammerspoon config install'
fi
