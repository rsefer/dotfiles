#!/usr/bin/env bash
source $DOTFILES_ROOT/.setup/functions.sh

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

install_utils () {
  info 'installing utility repos'

  UTILS_ROOT="$HOME/utils"

	if [ ! -d "$UTILS_ROOT" ]; then
		mkdir "$UTILS_ROOT"
	fi
  cd "$UTILS_ROOT"

	while read REPO
	do
		basename=$(basename "$REPO")
    filename=${basename%.*}
    if [ ! -d "$filename" ]; then
  		git clone "$REPO"
      success "cloned util $repo"
    else
      success "skipped cloning $REPO"
  	fi
	done < $SCRIPTPATH/repos.txt
}

user "install custom utilities? Y/n"
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
	install_utils
else
	success 'skipped custom utilities install'
fi
