#!/usr/bin/env bash
source $DOTFILES_ROOT/setup/functions.sh

install_homebrew () {
  if test ! $(which brew)
  then
    info 'installing Homebrew'
		if test "$(uname)" = "Darwin"
		then
			ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
		then
			sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
		fi
  fi
}

install_brews () {
  if test $(which brew)
  then
    info 'installing Homebrew brews Brewfile'
  	cd "$DOTFILES_ROOT/setup/installs/homebrew"
  	brew bundle --file='Brewfile'
  fi
}

install_casks () {
  if test $(which brew)
  then
    info 'installing Homebrew casks from Caskfile'
  	cd "$DOTFILES_ROOT/setup/installs/homebrew"
  	brew bundle --file='Caskfile'
  fi
}

readyn "install Homebrew (y/n)? "
if [[ $REPLY =~ ^[Yy]$ ]]
then
  install_homebrew
else
  success 'skipped Homebrew install'
fi

if test $(which brew)
then

	readyn "install Homebrew brews (y/n)? "
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		if install_brews
		then
			success 'succesfully installed brews'
		else
			fail 'brew installation had errors'
		fi
	else
		success 'skipped Homebrew brews install'
	fi

	if test "$(uname)" = "Darwin"
	then
		readyn "install Homebrew casks and apps from the Appstore (y/n)? "
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			if install_casks
			then
				success 'succesfully installed casks and apps'
			else
				fail 'cask installation had errors'
			fi
			info 'launching 1Password'
			open -a "1Password"
		else
			success 'skipped Homebrew casks and apps install'
		fi
	else
		success 'skipped Homebrew casks and apps install because this is not macOS'
	fi

fi
