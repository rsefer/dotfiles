#!/usr/bin/env bash
source $DOTFILES_ROOT/.setup/functions.sh

info 'installing Oh My Zsh'

chsh -s $(which zsh) # changes shell automatically
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

info 'installing custom oh my zsh theme'

overwrite_all=false backup_all=false skip_all=false
src="$DOTFILES_ROOT/zsh/rsefer.zsh-theme"
dst="$HOME/.oh-my-zsh/custom/themes/rsefer.zsh-theme"
link_file "$src" "$dst"