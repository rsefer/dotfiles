hs.window.animationDuration = 0

-- Size Left Half
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'L', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  f.w = max.w / 2
  f.y = max.y
  f.h = max.h
  win:setFrame(f)
end)

-- Size Right Half
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'R', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x + max.w / 2
  f.w = max.w / 2
  f.y = max.y
  f.h = max.h
  win:setFrame(f)
end)

-- Size Full
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'F', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  f.w = max.w
  f.y = max.y
  f.h = max.h
  win:setFrame(f)
end)

-- Size Center
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'C', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x + (max.w * 0.15)
  f.w = max.w * 0.7
  f.y = max.y + (max.h * 0.15)
  f.h = max.h * 0.7
  win:setFrame(f)
end)

-- Size Left 7.75/10
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'N', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  f.w = max.w * 0.775
  f.y = max.y
  f.h = max.h
  win:setFrame(f)
end)

-- Size Left 7.75/10 (offset 2.25)
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'X', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x + (max.w * 0.225)
  f.w = max.w * 0.550
  f.y = max.y
  f.h = max.h
  win:setFrame(f)
end)

-- Size Right 3/10
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'M', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x + (max.w * 0.775)
  f.w = max.w * 0.225
  f.y = max.y
  f.h = max.h
  win:setFrame(f)
end)

-- Size Right Top 3/10
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, ',', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x + (max.w * 0.775)
  f.w = max.w * 0.225
  f.y = max.y
  f.h = max.h * 0.55
  win:setFrame(f)
end)

-- Size Right Bottom 3/10
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, '.', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x + (max.w * 0.775)
  f.w = max.w * 0.225
  f.y = max.y + (max.h * 0.6)
  f.h = max.h * 0.4
  win:setFrame(f)
end)

-- Size Top Half
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'T', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.y = 0
  f.h = max.h / 2
  win:setFrame(f)
end)

-- Size Bottom Half
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 'B', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.y = max.h * 0.52
  f.h = max.h * 0.50
  win:setFrame(f)
end)

-- Move Left Edge
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, ';', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x
  win:setFrame(f)
end)

-- Move Right Edge
hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, "'", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x + max.w - f.w
  win:setFrame(f)
end)
