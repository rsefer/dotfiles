export DOTFILES_ROOT=$HOME/dotfiles
export UTILS_ROOT=$HOME/utils
export PATH="$DOTFILES_ROOT/bin:$PATH"
export EDITOR="code -w"

if [ -r $HOME/.aliases ]; then
  source $HOME/.aliases
fi

PATH="/usr/local/opt/curl/bin:$PATH"

eval "$(alias -s)"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="/usr/local/sbin:$PATH"

export PATH=$PATH:/usr/local/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
