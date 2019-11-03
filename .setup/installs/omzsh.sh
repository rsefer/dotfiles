#!/usr/bin/env bash
source $DOTFILES_ROOT/.setup/functions.sh

info 'installing Oh My Zsh'

chsh -s $(which zsh) # changes shell automatically
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

info 'installing custom oh my zsh theme'

overwrite_all=false backup_all=false skip_all=false

link_file "$DOTFILES_ROOT/zsh/rsefer.zsh-theme" "$HOME/.oh-my-zsh/themes/rsefer.zsh-theme"

info 'installing oh my zsh plugins'

cd ${$ZSH_CUSTOM:~/.oh-my-zsh}/custom/plugins/
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
