#!/usr/bin/env bash
source $DOTFILES_ROOT/setup/functions.sh

info 'installing dotfiles'

overwrite_all=false backup_all=false skip_all=false
for src in $(find -H "$DOTFILES_ROOT/dots" -maxdepth 1 -name '.*' ! -name '.DS_Store' -not -path '..' -not -path '.' -not -path '*.git*')
do
	dst="$HOME/$(basename "${src}")"
	link_file "$src" "$dst"
done
