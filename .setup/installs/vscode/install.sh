#!/usr/bin/env bash
source $DOTFILES_ROOT/.setup/functions.sh

rm -r ~/Library/Application\ Support/Code/User
ln -s $DOTFILES_ROOT/vscode.symlink/ ~/Library/Application\ Support/Code/User

# list current extensions: code --list-extensions > extensions.txt

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
info 'installing VS Code extensions'
LIST=""
while read EXTENSION
do
	LIST+="--install-extension $EXTENSION "
done < $SCRIPTPATH/extensions.txt
code $LIST
