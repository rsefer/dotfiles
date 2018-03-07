# Dotfiles

Based heavily on [Zach Holman's dotfiles](https://github.com/holman/dotfiles).

## My Initial Setup

1. Install [1Password](https://1password.com/downloads/)
2. Authenticate locally with [GitHub](https://help.github.com/articles/connecting-to-github-with-ssh/) and [GitLab](https://docs.gitlab.com/ce/ssh/README.html)
3. Run `.script/initial`
4. Add necessary config files

## Config Files

`hammerspoon.symlink/config.lua`:
```lua
keys = {
	darksky_api_key = '',
	latitude = '',
	longitude = ''
}
```

and individual config files in all `util` repositories:
- `git@gitlab.com:rsefer/server-scripts.git`
- `git@gitlab.com:rsefer/data.git`
- `git@gitlab.com:rsefer/git-scripts.git`
