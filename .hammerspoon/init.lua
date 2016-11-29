-- To find Hammerspoon preferences 1) Run Hammerspoon from Spotlight or run `open -a Hammerspoon` in the Terminal 2) Press Command + Comma

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

-- Window Management

hs.window.animationDuration = 0
hs.window.setFrameCorrectness = true
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDWIDTH = 100
hs.grid.GRIDHEIGHT = 100

local gridset = function(x, y, w, h)
  return function()
    local win = hs.window.focusedWindow()
    hs.grid.set(
      win,
      { x = x, y = y, w = w, h = h },
      win:screen()
    )
  end
end

local windowGridKeyCombo = {'cmd', 'alt', 'ctrl'}

-- Size Left Half
hs.hotkey.bind(windowGridKeyCombo, 'L', gridset(0, 0, 50, 100))
-- Size Right Half
hs.hotkey.bind(windowGridKeyCombo, 'R', gridset(50, 0, 50, 100))
-- Size Full
hs.hotkey.bind(windowGridKeyCombo, 'F', gridset(0, 0, 100, 100))
-- Size Centered
hs.hotkey.bind(windowGridKeyCombo, 'C', gridset(15, 15, 77.5, 70))
-- Size Left 2/3-ish
hs.hotkey.bind(windowGridKeyCombo, 'N', gridset(0, 0, 77.5, 100))
-- Size 2/3-ish Centered
hs.hotkey.bind(windowGridKeyCombo, 'X', gridset(11.25, 0, 77.5, 100))
-- Size Right 1/3-ish
hs.hotkey.bind(windowGridKeyCombo, 'M', gridset(77.5, 0, 30, 100))
-- Size Right 1/3-ish Top 1/2-ish
hs.hotkey.bind(windowGridKeyCombo, ',', gridset(77.5, 0, 30, 55))
-- Size Right 1/3-ish Bottom 1/2-ish
hs.hotkey.bind(windowGridKeyCombo, '.', gridset(77.5, 60, 30, 40))
-- Move to Top Edge
hs.hotkey.bind(windowGridKeyCombo, 'T', function()
  local win = hs.window.focusedWindow()
  local currentRect = hs.grid.get(win)
  hs.grid.set(
    win,
    { x = currentRect.x, y = 0, w = currentRect.w, h = currentRect.h },
    win:screen()
  )
end)
-- Move to Bottom Edge
hs.hotkey.bind(windowGridKeyCombo, 'B', function()
  local win = hs.window.focusedWindow()
  local currentRect = hs.grid.get(win)
  hs.grid.set(
    win,
    { x = currentRect.x, y = (100 - currentRect.h), w = currentRect.w, h = currentRect.h },
    win:screen()
  )
end)
-- Move to Left Edge
hs.hotkey.bind(windowGridKeyCombo, ';', function()
  local win = hs.window.focusedWindow()
  local currentRect = hs.grid.get(win)
  hs.grid.set(
    win,
    { x = 0, y = currentRect.y, w = currentRect.w, h = currentRect.h },
    win:screen()
  )
end)
-- Move to Right Edge
hs.hotkey.bind(windowGridKeyCombo, "'", function()
  local win = hs.window.focusedWindow()
  local currentRect = hs.grid.get(win)
  hs.grid.set(
    win,
    { x = (100 - currentRect.w), y = currentRect.y, w = currentRect.w, h = currentRect.h },
    win:screen()
  )
end)
