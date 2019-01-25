# Dock
defaults write com.apple.dock tilesize -int 48 # icon size
defaults write com.apple.dock orientation -string left # position
defaults write com.apple.dock autohide-time-modifier -float 0 # no hide/show delay
defaults write com.apple.dock autohide-delay -float 0 # no hide delay
killall Dock

# Finder
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # list view in Finder
killall Finder

# Misc.
defaults write com.apple.dashboard mcx-disabled -bool true # disable Dashboard
