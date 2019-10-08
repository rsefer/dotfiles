#!/usr/bin/env bash
source $DOTFILES_ROOT/.setup/functions.sh

# list current extensions: code --list-extensions > extensions.txt

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
info 'installing VS Code extensions'
LIST=""
while read EXTENSION
do
	LIST+="--install-extension $EXTENSION "
done < $SCRIPTPATH/extensions.txt
code $LIST
