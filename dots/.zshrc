source $HOME/.profile
source $DOTFILES_ROOT/zsh/keybindings.sh
source $DOTFILES_ROOT/zsh/nvmrc-autoswitch.sh

if type brew &>/dev/null; then

	HOMEBREW_PREFIX=$(brew --prefix)
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do export PATH=$d:$PATH; done

	export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/highlighters

	FPATH=${HOMEBREW_PREFIX}/share/zsh-completions:$FPATH
	source ${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	source ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

	autoload -Uz compinit && compinit

fi

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

source $HOME/.prompt
