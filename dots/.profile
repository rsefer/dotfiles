export DOTFILES_ROOT=$HOME/dotfiles
export EDITOR="code -w"
export NOTES_DIR="$HOME/Library/Mobile\ Documents/com~apple~CloudDocs"
export OLLAMA_HOST="http://ollama.spaniel-dragon.ts.net:11434/"
export LOCALHOSTSSLDIR=$HOME/.localhost-ssl
export CAROOT="${CAROOT:-$HOME/Library/Application Support/mkcert}"
if [ -f "$CAROOT/rootCA.pem" ]; then
	export NODE_EXTRA_CA_CERTS="$CAROOT/rootCA.pem"
fi
export SSL_KEY_PATH="$LOCALHOSTSSLDIR/key.pem"
export SSL_CRT_PATH="$LOCALHOSTSSLDIR/cert.pem"
export SSL_FTQ_KEY_PATH="$LOCALHOSTSSLDIR/ftq/key.pem"
export SSL_FTQ_CRT_PATH="$LOCALHOSTSSLDIR/ftq/cert.pem"
export HISTCONTROL=ignoredups
export SHELL_NAME="${SHELL##*/}"

export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"

export GOPATH="${GOPATH:-$HOME/go}"

BASE_DEV_PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/opt/curl/bin:$GOPATH/bin:$HOME/.composer/vendor/bin:$HOME/.pyenv/shims:/usr/local/sbin:/usr/local/bin:$DOTFILES_ROOT/bin"

# Local's shell entry script prepends site-specific PHP/WP-CLI paths before launching
# the shell. Preserve that ordering to avoid loading Homebrew PHP against Local extensions.
if [ -n "$WP_CLI_CONFIG_PATH" ]; then
	export PATH="$PATH:$BASE_DEV_PATH"
else
	export PATH="$BASE_DEV_PATH:$PATH"
fi

if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init -)"
fi

source $HOME/.aliases
if [ -f "$HOME/.config/op/plugins.sh" ]; then
	source $HOME/.config/op/plugins.sh
fi

if [ -f /opt/homebrew/opt/chruby/share/chruby/chruby.sh ] && [ -f /opt/homebrew/opt/chruby/share/chruby/auto.sh ]; then
	source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
	source /opt/homebrew/opt/chruby/share/chruby/auto.sh
	chruby ruby-2.7.4
fi


# fnm: manages node versions and automatically switches to the correct version based on .nvmrc or .node-version files
# see https://github.com/Schniz/fnm/blob/master/docs/configuration.md
if command -v fnm 1>/dev/null 2>&1; then
	eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell "$SHELL_NAME")"
fi

# starship: shell prompt
if command -v starship 1>/dev/null 2>&1; then
	eval "$(starship init "$SHELL_NAME")"
fi

# LocalWP: auto-select site shell when cd-ing into a Local site directory
LOCALWP_HOOK_RUNNING=0
LOCALWP_LAST_WP_ROOT=""
: ${LOCALWP_CLOSE_PARENT_SHELL_ON_EXIT:=1}

localwp_find_wp_root() {
	local local_root="$HOME/local"
	local p="$PWD"

	case "$p" in
		"$local_root"|"$local_root"/*) ;;
		*) return 1 ;;
	esac

	while [ "$p" != "/" ]; do
		if [ -f "$p/wp-config.php" ] || [ -d "$p/wp-content" ]; then
			printf '%s\n' "$p"
			return 0
		fi
		[ "$p" = "$local_root" ] && break
		p="${p%/*}"
	done

	return 1
}

localwp_auto_select() {
	local wp_root
	local localwp_cmd="${DOTFILES_ROOT:-$HOME/dotfiles}/bin/local-wp"

	# Prevent recursion when local-wp opens a nested shell.
	[ -n "$LOCAL_WP_ACTIVE" ] && return 0
	[ -n "$WP_CLI_CONFIG_PATH" ] && return 0
	[ "$LOCALWP_HOOK_RUNNING" = "1" ] && return 0
	[ -x "$localwp_cmd" ] || return 0

	wp_root="$(localwp_find_wp_root)" || {
		LOCALWP_LAST_WP_ROOT=""
		return 0
	}
	[ -n "$wp_root" ] || return 0
	[ "$wp_root" = "$LOCALWP_LAST_WP_ROOT" ] && return 0

	LOCALWP_HOOK_RUNNING=1
	if "$localwp_cmd"; then
		LOCALWP_LAST_WP_ROOT="$wp_root"
		LOCALWP_HOOK_RUNNING=0
		if [ "${LOCALWP_CLOSE_PARENT_SHELL_ON_EXIT}" = "1" ]; then
			exit
		fi
		return 0
	fi
	LOCALWP_HOOK_RUNNING=0
}

localwp_auto_select
