export DOTFILES_ROOT=$HOME/dotfiles
export UTILS_ROOT=$HOME/utils
export EDITOR="code -w"
export LOCALHOSTSSLDIR=$HOME/.localhost-ssl
export SSL_KEY_PATH="$LOCALHOSTSSLDIR/key.pem"
export SSL_CRT_PATH="$LOCALHOSTSSLDIR/cert.pem"

export PATH="/usr/local/opt/curl/bin:/usr/local/sbin:/usr/local/bin:$DOTFILES_ROOT/bin:$PATH:$HOME/.rvm/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

source $HOME/.aliases
