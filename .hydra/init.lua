function movewindow_leftside()
  local win = window.focusedwindow()
  local screenrect = win:screen():frame_including_dock_and_menu()
  local f = win:frame()
  f.x = screenrect.x
  f.w = screenrect.w / 2
  f.y = screenrect.y
  f.h = screenrect.h
  win:setframe(f)
end
hotkey.bind({"cmd", "ctrl", "alt"}, "L", movewindow_leftside)

function movewindow_rightside()
  local win = window.focusedwindow()
  local screenrect = win:screen():frame_including_dock_and_menu()
  local f = win:frame()
  f.x = screenrect.x + (screenrect.w / 2)
  f.w = screenrect.w / 2
  f.y = screenrect.y
  f.h = screenrect.h
  win:setframe(f)
end
hotkey.bind({"cmd", "ctrl", "alt"}, "R", movewindow_rightside)

function movewindow_full()
  local win = window.focusedwindow()
  local screenrect = win:screen():frame_including_dock_and_menu()
  local f = win:frame()
  f.x = screenrect.x
  f.w = screenrect.w
  f.y = screenrect.y
  f.h = screenrect.h
  win:setframe(f)
end
hotkey.bind({"cmd", "ctrl", "alt"}, "F", movewindow_full)

function movewindow_left710()
  local win = window.focusedwindow()
  local screenrect = win:screen():frame_including_dock_and_menu()
  local f = win:frame()
  f.x = screenrect.x
  f.w = screenrect.w * 0.7
  f.y = screenrect.y
  f.h = screenrect.h
  win:setframe(f)
end
hotkey.bind({"cmd", "ctrl", "alt"}, "N", movewindow_left710)

function movewindow_right310()
  local win = window.focusedwindow()
  local screenrect = win:screen():frame_including_dock_and_menu()
  local f = win:frame()
  f.x = screenrect.x + (screenrect.w * 0.7)
  f.w = screenrect.w * 0.3
  f.y = screenrect.y
  f.h = screenrect.h
  win:setframe(f)
end
hotkey.bind({"cmd", "ctrl", "alt"}, "M", movewindow_right310)

function movewindow_right310Top()
  local win = window.focusedwindow()
  local screenrect = win:screen():frame_including_dock_and_menu()
  local f = win:frame()
  f.x = screenrect.x + (screenrect.w * 0.7)
  f.w = screenrect.w * 0.3
  f.y = screenrect.y
  f.h = screenrect.h * 0.6
  win:setframe(f)
end
hotkey.bind({"cmd", "ctrl", "alt"}, ",", movewindow_right310Top)

function movewindow_right310Bottom()
  local win = window.focusedwindow()
  local screenrect = win:screen():frame_including_dock_and_menu()
  local f = win:frame()
  f.x = screenrect.x + (screenrect.w * 0.7)
  f.w = screenrect.w * 0.3
  f.y = screenrect.y + (screenrect.h * 0.6)
  f.h = screenrect.h * 0.4
  win:setframe(f)
end
hotkey.bind({"cmd", "ctrl", "alt"}, ".", movewindow_right310Bottom)

function movewindow_center()
  local win = window.focusedwindow()
  local screenrect = win:screen():frame_including_dock_and_menu()
  local f = win:frame()
  f.x = screenrect.x + (screenrect.w * 0.15)
  f.w = screenrect.w * 0.7
  f.y = screenrect.y + (screenrect.h * 0.15)
  f.h = screenrect.h * 0.7
  win:setframe(f)
end
hotkey.bind({"cmd", "ctrl", "alt"}, "C", movewindow_center)

-- Hi!
-- show a helpful menu
hydra.menu.show(function()
    local t = {
      {title = "Reload Config", fn = hydra.reload},
      {title = "Open REPL", fn = repl.open},
      {title = "-"},
      {title = "About Hydra", fn = hydra.showabout},
      {title = "Check for Updates...", fn = function() hydra.updates.check(nil, true) end},
      {title = "Quit", fn = os.exit},
    }

    if not hydra.license.haslicense() then
      table.insert(t, 1, {title = "Buy or Enter License...", fn = hydra.license.enter})
      table.insert(t, 2, {title = "-"})
    end

    return t
end)

-- uncomment this line if you want Hydra to make sure it launches at login
-- hydra.autolaunch.set(true)

-- when the "update is available" notification is clicked, open the website
notify.register("showupdate", function() os.execute('open https://github.com/sdegutis/Hydra/releases') end)

-- check for updates every week, and also right now (when first launching)
timer.new(timer.weeks(1), hydra.updates.check):start()
hydra.updates.check()
