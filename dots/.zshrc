plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
autoload -U compinit && compinit

ZSH_THEME="rsefer"

export ZSH=$HOME/.oh-my-zsh

source $HOME/.profile
source $ZSH/oh-my-zsh.sh
source $DOTFILES_ROOT/zsh/keybindings.sh

if [ -r $HOME/.aliases ]; then
  source $HOME/.aliases
fi

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/rsefer/.nvm/versions/node/v9.9.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/rsefer/.nvm/versions/node/v9.9.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/rsefer/.nvm/versions/node/v9.9.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/rsefer/.nvm/versions/node/v9.9.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/rsefer/.nvm/versions/node/v9.9.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/rsefer/.nvm/versions/node/v9.9.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh
