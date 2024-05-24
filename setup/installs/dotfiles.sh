#!/usr/bin/env bash
source $DOTFILES_ROOT/setup/functions.sh

info 'installing dotfiles'

overwrite_all=false backup_all=false skip_all=false
for src in $(find -H "$DOTFILES_ROOT/dots" -maxdepth 1 -name '.*' ! -name '.DS_Store' ! -name '.config' -not -path '..' -not -path '.' -not -path '*.git*')
do
	dst="$HOME/$(basename "${src}")"
	link_file "$src" "$dst"
done

# .config is treated differently
for src in $(find -H "$DOTFILES_ROOT/dots/.config" -maxdepth 1 ! -name '.DS_Store' ! -name '.config' -not -path '..' -not -path '.' -not -path '*.git*')
do
	dst="$HOME/.config/$(basename "${src}")"
	link_file "$src" "$dst"
done

info 'installing Vim plugins'
if [[ ! -d $DOTFILES_ROOT/dots/.vim/bundle/Vundle.vim ]]; then
	git clone https://github.com/VundleVim/Vundle.vim.git $DOTFILES_ROOT/dots/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +qall
