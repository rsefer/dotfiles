function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function gridset(x, y, w, h)
  return function()
    local currentwin = hs.window.focusedWindow()
    local currentRect = hs.grid.get(currentwin)
    local win = hs.window.focusedWindow()
    if x == 'current' then
      x = currentRect.x
    elseif x == 'opp' then
      x = 100 - currentRect.w
    end
    if y == 'current' then
      y = currentRect.y
    end
    if w == 'current' then
      w = currentRect.w
    end
    if h == 'current' then
      h = currentRect.h
    end
    hs.grid.set(
      win,
      { x = x, y = y, w = w, h = h },
      win:screen()
    )
  end
end
