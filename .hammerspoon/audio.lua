-- Audio Switcher
local audioSwitcherDisplay = hs.menubar.new()
hs.audiodevice.defaultOutputDevice()

function audioSwitcherSet(default)
  local newAudioDevice = hs.audiodevice.findOutputByName("Built-in Output")
  local menuTitle = "🔈🖥"
  if newAudioDevice:jackConnected() then
    menuTitle = "🔈🎧"
  end
  local airportName = "AirPort Express"
  -- Currently the detection of the APEx. does not work on macOS 10.12 Sierra
  if default == false and hs.audiodevice.findOutputByUID(airportName) then
    newAudioDevice = hs.audiodevice.findOutputByName(airportName)
    menuTitle = "🔈📻"
  end
  newAudioDevice:setDefaultOutputDevice()
  audioSwitcherDisplay:setTitle(menuTitle)
end

if audioSwitcherDisplay then
  audioSwitcherDisplay:setClickCallback(audioSwitcherSet)
  audioSwitcherSet(true)
end
