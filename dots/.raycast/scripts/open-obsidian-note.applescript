#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Obsidian Note
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📝

# Documentation:
# @raycast.author rsefer
# @raycast.authorURL https://raycast.com/rsefer

tell application "Obsidian" to activate
delay 0.25
tell application "System Events" to tell application process "Obsidian" to keystroke "o" using command down
