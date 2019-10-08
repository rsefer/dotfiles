#!/usr/bin/env bash
source $DOTFILES_ROOT/.setup/functions.sh

info 'installing dotfiles'

overwrite_all=false backup_all=false skip_all=false
for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
do
	dst="$HOME/.$(basename "${src%.*}")"
	link_file "$src" "$dst"
done
