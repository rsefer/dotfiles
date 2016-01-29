local application = require 'mjolnir.application'
local hotkey = require 'mjolnir.hotkey'
local window = require 'mjolnir.window'
local screen = require 'mjolnir.screen'
local fnutils = require 'mjolnir.fnutils'

-- win:screen():frame() vs win:screen():fullframe()

-- Size Left Half
hotkey.bind({'cmd', 'alt', 'ctrl'}, 'L', function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.x = sc.x
  f.w = sc.w / 2
  f.y = sc.y
  f.h = sc.h
  win:setframe(f)
end)

-- Size Right Half
hotkey.bind({'cmd', 'alt', 'ctrl'}, 'R', function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.x = sc.x + sc.w / 2
  f.w = sc.w / 2
  f.y = sc.y
  f.h = sc.h
  win:setframe(f)
end)

-- Size Full
hotkey.bind({'cmd', 'alt', 'ctrl'}, 'F', function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.x = sc.x
  f.w = sc.w
  f.y = sc.y
  f.h = sc.h
  win:setframe(f)
end)

-- Size Center
hotkey.bind({'cmd', 'alt', 'ctrl'}, 'C', function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.x = sc.x + (sc.w * 0.15)
  f.w = sc.w * 0.7
  f.y = sc.y + (sc.h * 0.15)
  f.h = sc.h * 0.7
  win:setframe(f)
end)

-- Size Left 7.75/10
hotkey.bind({'cmd', 'alt', 'ctrl'}, 'N', function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.x = sc.x
  f.w = sc.w * 0.775
  f.y = sc.y
  f.h = sc.h
  win:setframe(f)
end)

-- Size Left 7.75/10 (offset 2.25)
hotkey.bind({'cmd', 'alt', 'ctrl'}, 'X', function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.x = sc.x + (sc.w * 0.225)
  f.w = sc.w * 0.550
  f.y = sc.y
  f.h = sc.h
  win:setframe(f)
end)

-- Size Right 3/10
hotkey.bind({'cmd', 'alt', 'ctrl'}, 'M', function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.x = sc.x + (sc.w * 0.775)
  f.w = sc.w * 0.225
  f.y = sc.y
  f.h = sc.h
  win:setframe(f)
end)

-- Size Right Top 3/10
hotkey.bind({'cmd', 'alt', 'ctrl'}, ',', function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.x = sc.x + (sc.w * 0.775)
  f.w = sc.w * 0.225
  f.y = sc.y
  f.h = sc.h * 0.55
  win:setframe(f)
end)

-- Size Right Bottom 3/10
hotkey.bind({'cmd', 'alt', 'ctrl'}, '.', function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.x = sc.x + (sc.w * 0.775)
  f.w = sc.w * 0.225
  f.y = sc.y + (sc.h * 0.6)
  f.h = sc.h * 0.4
  win:setframe(f)
end)

-- Size Top Half
hotkey.bind({'cmd', 'alt', 'ctrl'}, "T", function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.y = 0
  f.h = sc.h / 2
  win:setframe(f)
end)

-- Size Bottom Half
hotkey.bind({'cmd', 'alt', 'ctrl'}, "B", function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.y = sc.h / 2
  f.h = sc.h / 2
  print(sc.y / 2)
  print(sc.h)
  win:setframe(f)
end)

-- Move Left Edge
hotkey.bind({'cmd', 'alt', 'ctrl'}, ";", function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.x = sc.x
  win:setframe(f)
end)

-- Move Right Edge
hotkey.bind({'cmd', 'alt', 'ctrl'}, "'", function()
  local win = window.focusedwindow()
  local sc = win:screen():frame()
  local f = win:frame()
  f.x = sc.x + sc.w - f.w
  win:setframe(f)
end)
