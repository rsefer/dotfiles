source $HOME/.profile
source $DOTFILES_ROOT/zsh/keybindings.sh

if type brew &>/dev/null; then

	HOMEBREW_PREFIX=$(brew --prefix)
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do export PATH=$d:$PATH; done

	export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/highlighters

	FPATH=${HOMEBREW_PREFIX}/share/zsh-completions:$FPATH
	source ${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	source ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

	autoload -Uz compinit && compinit

fi

source $HOME/.prompt
