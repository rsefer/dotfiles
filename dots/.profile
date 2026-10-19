export DOTFILES_ROOT=$HOME/dotfiles
export EDITOR="code -w"
export NOTES_DIR="$HOME/Library/Mobile\ Documents/com~apple~CloudDocs"
# export OLLAMA_HOST="http://ollama.spaniel-dragon.ts.net:11434/"
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

export PATH="$HOME/Library/Application Support/Local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/opt/curl/bin:$GOPATH/bin:$HOME/.composer/vendor/bin:$HOME/.pyenv/shims:/usr/local/sbin:/usr/local/bin:$DOTFILES_ROOT/bin:$PATH"

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

wp() {
	local site_name=""
	local sites_json="$HOME/Library/Application Support/Local/sites.json"
	local cwd site_path candidate_name match_length=0

	if [ -f "$sites_json" ] && command -v jq >/dev/null 2>&1; then
		cwd="$(pwd -P)" || return 1
		site_name="$(
			while IFS= read -r -d '' site_path && IFS= read -r -d '' candidate_name; do
				case "$site_path" in
					('~') site_path="$HOME" ;;
					('~/'*) site_path="$HOME/${site_path#\~/}" ;;
				esac
				site_path="$(CDPATH= cd -- "$site_path" 2>/dev/null && pwd -P)" || continue
				case "$cwd" in
					("$site_path"|"$site_path"/*)
						if [ "${#site_path}" -gt "$match_length" ]; then
							site_name="$candidate_name"
							match_length="${#site_path}"
						fi
						;;
				esac
			done < <(command jq -j '
				.[] | objects
				| select((.path | type) == "string" and (.name | type) == "string")
				| select(.path != "" and .name != "")
				| .path, "\u0000", .name, "\u0000"
			' "$sites_json" 2>/dev/null)
			printf '%s' "$site_name"
		)"
	fi

	if [ -n "$site_name" ]; then
		echo "localwp cli \"$site_name\" -- $@"
		command env -u NODE_OPTIONS localwp cli "$site_name" -- "$@"
	else
		command wp "$@"
	fi
}
