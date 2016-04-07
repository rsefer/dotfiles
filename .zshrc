# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="pure"

plugins=(git heroku)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="$PATH:/Users/rsefer/.rvm/gems/ruby-2.1.5/bin:/Users/rsefer/.rvm/gems/ruby-2.0.0-p353/bin:/Users/rsefer/.rvm/gems/ruby-2.0.0-p353@global/bin:/Users/rsefer/.rvm/rubies/ruby-2.0.0-p353/bin:/Users/rsefer/.rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/opt/sm/bin:/opt/sm/pkg/active/bin:/opt/sm/pkg/active/sbin"

export PATH=$PATH:/usr/local/bin

export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

eval "$(hub alias -s)"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

alias idk="printf \"¯\_(ツ)_/¯\" | pbcopy && echo \"¯\_(ツ)_/¯ copied to clipboard\""
export PATH="/usr/local/sbin:$PATH"
