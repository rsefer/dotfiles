source $HOME/.profile
source $DOTFILES_ROOT/zsh/keybindings.sh

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

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# manage node version and automatically switch to the correct version based on .nvmrc or .node-version files
# see https://github.com/Schniz/fnm/blob/master/docs/configuration.md
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"

# source $HOME/.prompt
eval "$(starship init zsh)"
