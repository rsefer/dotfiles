-- Overcast
local overcastMenubar = hs.menubar.new()
local overcastWebview = nil
local overcastWebviewStatus = false
local overcastWebviewToolbar = hs.webview.toolbar.new('overcastWebviewToolbar')

function launchOvercastWebview(mouseX, mouseY)
  local title = 'Overcast'
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local max = screen:frame()
  local wWidth = 320
  local wHeight = 500
  local rect = hs.geometry.rect(mouseX - (wWidth / 2), mouseY, 320, 500)
  overcastWebview = hs.webview.new(rect)
    :url('https://overcast.fm/podcasts')
    :allowTextEntry(true)
    :windowTitle(title)
    :windowStyle(1)
    :closeOnEscape(true)
    :toolbar(overcastWebviewToolbar)
end

function toggleOvercastWebview()
  if overcastWebviewStatus then
    overcastWebview:hide()
    overcastWebviewStatus = false
  else
    if overcastWebview == nil then
      local mousePoint = hs.mouse.getAbsolutePosition()
      launchOvercastWebview(mousePoint.x, mousePoint.y)
    end
    overcastWebview:show():bringToFront(true)
    overcastWebviewStatus = true
  end
end

if overcastMenubar then
  overcastMenubar:setClickCallback(toggleOvercastWebview)
  local overcastImageOrange = hs.image.imageFromPath('icons/overcast_black.pdf'):setSize({ w = 16, h = 16 })
  overcastMenubar:setIcon(overcastImageOrange)
end
