source $HOME/.profile
source $HOME/.prompt
source $DOTFILES_ROOT/zsh/keybindings.sh

if type brew &>/dev/null; then

	export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$(brew --prefix)/share/zsh-syntax-highlighting/highlighters

	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
	source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

	autoload -Uz compinit && compinit

fi
