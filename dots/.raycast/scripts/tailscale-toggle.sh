#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Tailscale Toggle
# @raycast.mode silent
# @raycast.packageName Tailscale

# Optional parameters:
# @raycast.icon assets/tailscale.png

# Documentation:
# @raycast.author rsefer
# @raycast.authorURL https://raycast.com/rsefer

TAILSCALE_COMMAND_LOCATION=/Applications/Tailscale.app/Contents/MacOS/Tailscale
JQ_COMMAND_LOCATION=/opt/homebrew/bin/jq

function getBackendState() {
	BACKEND_STATE=$($TAILSCALE_COMMAND_LOCATION status --json | $JQ_COMMAND_LOCATION -r '.BackendState')
}

getBackendState
if [[ $BACKEND_STATE == *Running* ]]; then
	$TAILSCALE_COMMAND_LOCATION down
else
	$TAILSCALE_COMMAND_LOCATION up
fi

getBackendState
echo "Tailscale $BACKEND_STATE"
exit 0
