-- Overcast
local overcastWebview = nil
local isShown = false
local iconSize = 14.0
local updateStatusTimer = nil
local iconOrange = hs.image.imageFromPath('images/overcast_orange.pdf'):setSize({ w = iconSize, h = iconSize })
local iconBlack = hs.image.imageFromPath('images/overcast_black.pdf'):setSize({ w = iconSize, h = iconSize })

function toggleWebview()
  if isShown then
    overcastWebview:hide()
    isShown = false
  else
    overcastWebview:show():bringToFront(true)
    isShown = true
  end
end

local overcastMenu = hs.menubar.new()
overcastMenu:setClickCallback(toggleWebview)
overcastMenu:setIcon(iconBlack, false)
local overcastMenuFrame = overcastMenu:frame()

local screen = hs.window.focusedWindow():screen()
local max = screen:frame()
local margin = 100
local viewWidth = 350
local viewHeight = 400
local rect = hs.geometry.rect((overcastMenuFrame.x + overcastMenuFrame.w / 2) - (viewWidth / 2), overcastMenuFrame.y, viewWidth, viewHeight)
local name = 'id' .. hs.host.uuid():gsub('-', '')
local js = hs.webview.usercontent.new(name)
localjsScript = "$('.navlink:eq(1), .fullart_container, #speedcontrols').css('display', 'none'); $('h2.ocseparatorbar:first()').css('margin-top', '0px');" .. "setInterval(function() { webkit.messageHandlers." .. name .. ".postMessage({ isPlaying: !$('audio').prop('paused') }); }, 3000);"
js:injectScript({ source = localjsScript, mainFrame = true, injectionTime = 'documentEnd' }):setCallback(function(message)
  if message.body.isPlaying then
    overcastMenu:setIcon(iconOrange, false)
  else
    overcastMenu:setIcon(iconBlack, false)
  end
end)

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
