# Dock
defaults write com.apple.dock tilesize -int 48 # icon size
defaults write com.apple.dock orientation -string left # position
defaults write com.apple.dock autohide-time-modifier -float 0 # hide/show delay timing
defaults write com.apple.dock autohide-delay -float 0 # auto-hiding delay timing

defaults write com.apple.dashboard mcx-disabled -bool true # disable Dashboard

killall Dock
