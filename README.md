# Dotfiles

Based heavily on [Zach Holman's dotfiles](https://github.com/holman/dotfiles). Hammerspoon config was originally included but is now in a [separate repository](https://github.com/rsefer/hammerspoon-config).

## Initial Setup

1. Authenticate locally with [GitHub](https://help.github.com/articles/connecting-to-github-with-ssh/) and set up git credentials:
```
git config --global user.name "First Last"
git config --global user.email "me@example.com"
```
2. `cd ~/ && git clone https://github.com/rsefer/dotfiles.git && source dotfiles/.setup/initial`
3. Add necessary config files in all `util` repositories
