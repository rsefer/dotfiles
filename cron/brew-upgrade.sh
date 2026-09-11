#!/bin/bash
# cron: 0 2 * * *

source $DOTFILES_ROOT/setup/functions.sh

info "Homebrew Upgrade Started: $(date)"

upgrade () {
	local statuses
	info "brew upgrade $*"
	yes | brew upgrade "$@" 2>&1 | grep -E "(Upgraded|Error|brew:|==)"
	# plain assignment keeps PIPESTATUS from the pipeline above
	statuses=("${PIPESTATUS[@]}")
	if [ "${statuses[1]}" -ne 0 ]; then
		fail "brew upgrade $* failed"
	else
		plus "brew upgrade $* completed"
	fi
}

upgrade
upgrade --cask

success "Upgrade Completed: $(date)"
