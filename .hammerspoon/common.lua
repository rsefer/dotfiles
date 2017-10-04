function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function gridset(x1, y1, w1, h1)
  return function()
    local currentwin = hs.window.focusedWindow()
    local currentRect = hs.grid.get(currentwin)
    local win = hs.window.focusedWindow()
    if x1 == 'current' then
      x2 = currentRect.x
    elseif x1 == 'opp' then
      x2 = 100 - currentRect.w
    else
      x2 = x1
    end
    if y1 == 'current' then
      y2 = currentRect.y
    else
      y2 = y1
    end
    if w1 == 'current' then
      w2 = currentRect.w
    else
      w2 = w1
    end
    if h1 == 'current' then
      h2 = currentRect.h
    else
      h2 = h1
    end
    hs.grid.set(
      win,
      { x = x2, y = y2, w = w2, h = h2 },
      win:screen()
    )
  end
end
