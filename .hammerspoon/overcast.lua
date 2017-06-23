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
overcastMenu:setIcon(iconBlack, true)
local overcastMenuFrame = overcastMenu:frame()

local viewWidth = 350
local viewHeight = 400
local rect = hs.geometry.rect((overcastMenuFrame.x + overcastMenuFrame.w / 2) - (viewWidth / 2), overcastMenuFrame.y, viewWidth, viewHeight)
local name = 'id' .. hs.host.uuid():gsub('-', '')
local js = hs.webview.usercontent.new(name)
localjsScript = "$('.navlink:eq(1), #speedcontrols').css('display', 'none'); $('h2.ocseparatorbar:first()').css('margin-top', '0px'); $('.titlestack').prev().removeClass('marginbottom1').css('margin-bottom', '8px'); $('#progressbar').css('margin-top', '8px'); $('.fullart_container').css('float', 'left').css('width', '20%'); $('#speedcontrols').next().css('font-size', '12px').css('clear', 'both').css('margin-top', '20px'); $('#playcontrols_container').css('margin', '13px 0px 13px 20%').css('width', '80%'); " .. "setInterval(function() { var isAudioPlaying = false; if ($('#audioplayer').length > 0 && !$('#audioplayer').prop('paused')) { isAudioPlaying = true; } webkit.messageHandlers." .. name .. ".postMessage({ isPlaying: isAudioPlaying }); }, 3000);"
js:injectScript({ source = localjsScript, mainFrame = true, injectionTime = 'documentEnd' }):setCallback(function(message)
  if message.body.isPlaying then
    overcastMenu:setIcon(iconOrange, false)
  else
    overcastMenu:setIcon(iconBlack, true)
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
