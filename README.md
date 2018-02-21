# Dotfiles

Based heavily on [Zach Holman's dotfiles](https://github.com/holman/dotfiles).

## Initial Setup

Run `.script/initial`.

## Config Files

`hammerspoon.symlink/config.lua`:
```
keys = {
	darksky_api_key = '',
	latitude = '',
	longitude = ''
}
```

and individual config files in all `util` repositories:
- `git@gitlab.com:rsefer/server-scripts.git`
- `git@gitlab.com:rsefer/data.git`
