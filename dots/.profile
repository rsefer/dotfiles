export DOTFILES_ROOT=$HOME/dotfiles
export UTILS_ROOT=$HOME/utils
export EDITOR="code -w"
export NOTES_DIR="$HOME/Library/Mobile\ Documents/com~apple~CloudDocs"
export OLLAMA_HOST="http://raspberrypi-ollama.spaniel-dragon.ts.net:11434"
export LOCALHOSTSSLDIR=$HOME/.localhost-ssl
export SSL_KEY_PATH="$LOCALHOSTSSLDIR/key.pem"
export SSL_CRT_PATH="$LOCALHOSTSSLDIR/cert.pem"
export HISTCONTROL=ignoredups

export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"

export NODE_PATH="$(which node)"

export PATH="/opt/homebrew/opt/curl/bin:$HOME/.composer/vendor/bin:$HOME/.pyenv/shims:/usr/local/sbin:/usr/local/bin:$NODE_PATH:$DOTFILES_ROOT/bin:$PATH:$HOME/.rvm/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init -)"
fi

source $HOME/.config/op/plugins.sh

source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-2.7.4

source $HOME/.aliases

source $HOME/.config/op/plugins.sh

echo -e "=================="
echo -e " Sefer Design Co. "
echo -e "=================="
