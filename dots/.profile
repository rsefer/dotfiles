export DOTFILES_ROOT=$HOME/dotfiles
export EDITOR="code -w"
export NOTES_DIR="$HOME/Library/Mobile\ Documents/com~apple~CloudDocs"
export OLLAMA_HOST="http://ollama.spaniel-dragon.ts.net:11434/"
export LOCALHOSTSSLDIR=$HOME/.localhost-ssl
export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"
export SSL_KEY_PATH="$LOCALHOSTSSLDIR/key.pem"
export SSL_CRT_PATH="$LOCALHOSTSSLDIR/cert.pem"
export SSL_FTQ_KEY_PATH="$LOCALHOSTSSLDIR/ftq/key.pem"
export SSL_FTQ_CRT_PATH="$LOCALHOSTSSLDIR/ftq/cert.pem"
export HISTCONTROL=ignoredups

export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"

export NODE_PATH="$(which node)"

export PATH="/opt/homebrew/opt/curl/bin:$(go env GOPATH)/bin:$HOME/.composer/vendor/bin:$HOME/.pyenv/shims:/usr/local/sbin:/usr/local/bin:$NODE_PATH:$DOTFILES_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init -)"
fi

source $HOME/.config/op/plugins.sh

source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-2.7.4

source $HOME/.aliases

source $HOME/.config/op/plugins.sh

# fnm: manages node versions and automatically switches to the correct version based on .nvmrc or .node-version files
# see https://github.com/Schniz/fnm/blob/master/docs/configuration.md
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell $(basename $SHELL))"

# starship: shell prompt
eval "$(starship init $(basename $SHELL))"
