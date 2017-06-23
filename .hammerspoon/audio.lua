-- Audio Switcher
local audioSwitcherDisplay = hs.menubar.new()
local activeAudioSlug = 'headphones'
hs.audiodevice.defaultOutputDevice()

function audioSwitcherSet()

  if (hs.audiodevice.findOutputByName('USB Audio Device')) then
    if activeAudioSlug == 'headphones' then
      activeAudioSlug = 'built-in'
      activeAudioName = 'Built-in Output'
      menuTitle = '🖥'
    else
      activeAudioSlug = 'headphones'
      activeAudioName = 'USB Audio Device'
      menuTitle = '🎧'
    end
  else
    activeAudioSlug = 'built-in'
    activeAudioName = 'Built-in Output'
    menuTitle = '🖥'
  end
  hs.audiodevice.findOutputByName(activeAudioName):setDefaultOutputDevice()
  audioSwitcherDisplay:setTitle('🔈' .. menuTitle)
end

if audioSwitcherDisplay then
  audioSwitcherDisplay:setClickCallback(audioSwitcherSet)
  audioSwitcherSet()
end
