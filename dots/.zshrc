source $HOME/.profile
source $DOTFILES_ROOT/zsh/keybindings.sh

autoload -Uz add-zsh-hook

if (( ${chpwd_functions[(Ie)localwp_auto_select]} == 0 )); then
	add-zsh-hook chpwd localwp_auto_select
fi

typeset -gU path fpath

if [[ -z "$HOMEBREW_PREFIX" ]]; then
	if [[ -d /opt/homebrew ]]; then
		export HOMEBREW_PREFIX=/opt/homebrew
	elif [[ -d /usr/local/opt ]]; then
		export HOMEBREW_PREFIX=/usr/local
	fi
fi

if [[ -n "$HOMEBREW_PREFIX" ]]; then
	ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
	HOMEBREW_GNUBIN_CACHE=$ZSH_CACHE_DIR/homebrew-gnubin-paths.zsh
	ZCOMPDUMP_PATH=${ZDOTDIR:-$HOME}/.zcompdump

	if [[ ! -d "$ZSH_CACHE_DIR" ]]; then
		command mkdir -p "$ZSH_CACHE_DIR"
	fi

	if [[ ! -f "$HOMEBREW_GNUBIN_CACHE" || -n ${HOMEBREW_GNUBIN_CACHE}(#qN.mh+24) ]]; then
		{
			print -r -- 'typeset -gaU path'
			for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin(N-/); do
				print -r -- "path=($d \$path)"
			done
		} >| "$HOMEBREW_GNUBIN_CACHE"
	fi

	source "$HOMEBREW_GNUBIN_CACHE"

	export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/highlighters

	fpath=(${HOMEBREW_PREFIX}/share/zsh-completions $fpath)
	source ${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	source ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

	autoload -Uz compinit
	if [[ ! -f "$ZCOMPDUMP_PATH" || -n ${ZCOMPDUMP_PATH}(#qN.mh+24) ]]; then
		compinit -d "$ZCOMPDUMP_PATH"
	else
		compinit -C -d "$ZCOMPDUMP_PATH"
	fi

fi

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
