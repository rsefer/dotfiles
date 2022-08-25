#!/usr/bin/env bash
source $DOTFILES_ROOT/setup/functions.sh

rm -r ~/Library/Mobile\ Documents/com~apple~CloudDocs/Notes/.obsidian
ln -s $DOTFILES_ROOT/dots/.obsidian/ ~/Library/Mobile\ Documents/com~apple~CloudDocs/Notes/.obsidian
