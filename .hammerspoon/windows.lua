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
hs.hotkey.bind(windowGridKeyCombo, 'C', gridset(12.5, 12.5, 75, 75))
-- Size Left 3/4ths
hs.hotkey.bind(windowGridKeyCombo, 'N', gridset(0, 0, 75, 100))
-- Size 3/4ths Centered
hs.hotkey.bind(windowGridKeyCombo, 'X', gridset(12.5, 0, 75, 100))
-- Size Right 1/4th
hs.hotkey.bind(windowGridKeyCombo, 'M', gridset(75, 0, 25, 100))
-- Size Right 1/4th Top 1/2-ish
hs.hotkey.bind(windowGridKeyCombo, ',', gridset(75, 0, 25, 55))
-- Size Right 1/4th Bottom 1/2-ish
hs.hotkey.bind(windowGridKeyCombo, '.', gridset(75, 60, 25, 40))
-- Size Half Height, Top Edge
hs.hotkey.bind(windowGridKeyCombo, 'T', function()
  local win = hs.window.focusedWindow()
  local currentRect = hs.grid.get(win)
  hs.grid.set(
    win,
    { x = currentRect.x, y = 0, w = currentRect.w, h = 50 },
    win:screen()
  )
end)
-- Size Half Height, Bottom Edge
hs.hotkey.bind(windowGridKeyCombo, 'B', function()
  local win = hs.window.focusedWindow()
  local currentRect = hs.grid.get(win)
  hs.grid.set(
    win,
    { x = currentRect.x, y = 50, w = currentRect.w, h = 50 },
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
