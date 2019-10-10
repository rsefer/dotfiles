# Dotfiles

Based heavily on [Zach Holman's dotfiles](https://github.com/holman/dotfiles).

## My Initial Setup

1. Install [1Password](https://1password.com/downloads/)
2. Authenticate locally with [GitHub](https://help.github.com/articles/connecting-to-github-with-ssh/) and [GitLab](https://docs.gitlab.com/ce/ssh/README.html)
3. Run `.setup/initial`
4. If VS Code is installed, symlink config properly: ```rm -rf ~/Library/Application\ Support/Code/User && ln -s ~/dotfiles/vscode.symlink/ ~/Library/Application\ Support/Code/User```
5. Add necessary config files

## Config Files
Individual config files in all `util` repositories:
- `git@github.com:rsefer/server-scripts.git`
- `git@github.com:rsefer/data.git`
- `git@github.com:rsefer/git-scripts.git`
- `git@github.com:rsefer/mac-scripts.git`
