-- Overcast
local overcastWebview = nil
local isShown = false
local iconSize = 14.0

function toggleWebview()
  if isShown then
    overcastWebview:hide()
    isShown = false
  else
    overcastWebview:show()
    isShown = true
  end
end

local overcastMenu = hs.menubar.new()
overcastMenu:setClickCallback(toggleWebview)
local icon = hs.image.imageFromPath('images/overcast_orange.pdf')
overcastMenu:setIcon(icon:setSize({ w = iconSize, h = iconSize }))
local overcastMenuFrame = overcastMenu:frame()

local screen = hs.window.focusedWindow():screen()
local max = screen:frame()
local margin = 100
local viewWidth = 350
local viewHeight = 500
local rect = hs.geometry.rect((overcastMenuFrame.x + overcastMenuFrame.w / 2) - (viewWidth / 2), overcastMenuFrame.y, viewWidth, viewHeight)
local js = hs.webview.usercontent.new(hs.host.uuid()):setCallback(callback)
js:injectScript({ source = "$('.navlink:eq(1)').remove()", mainFrame = true, injectionTime = 'documentEnd' })

overcastWebview = hs.webview.new(rect, { developerExtrasEnabled = true }, js)
  :url('https://overcast.fm/podcasts')
  :allowGestures(true)
  :windowStyle({
    titled = false
  })
  :shadow(true)

if overcastMenu then
  overcastMenu:setClickCallback(toggleWebview)
end
