--- === SDC Finance ===
local obj = {}
obj.__index = obj
obj.name = "SDCFinance"

-- Cryptocurrencies to display (likely in reverse order)
-- User Coinmarketcap slug
local cryptocurrencies = {'bitcoin', 'ethereum'}
local localcurrency = 'USD'
local updateInterval = 60 * 5 -- seconds
local fontSize = 14.0

local menusCrypto = {}
local updateTimer = nil

-- https://stackoverflow.com/a/10992898
function numWithCommas(n)
  return tostring(math.floor(n)):reverse():gsub('(%d%d%d)','%1,'):gsub(',(%-?)$','%1'):reverse()
end

function updateTimerSet()
  updateTimer = hs.timer.doEvery(updateInterval, function()
    updateAllCrypto()
  end)
end

function updateCrypto(currency, menu_item)
  status, data, headers = hs.http.get('https://api.coinmarketcap.com/v1/ticker/' .. currency .. '/?convert=' .. localcurrency, {})
  if status == 200 then
    for k, v in pairs(hs.json.decode(data)) do
      for k2, v2 in pairs(v) do
        if k2 == 'price_usd' then
          menuTitleString = math.floor(v2 * 1000) / 1000
        end
      end
    end
    menuTitle = ' ' .. numWithCommas(menuTitleString)
    if useIcons == false then
      menuTitle = currency .. menuTitle
    end
    menu_item:setTitle(hs.styledtext.new(menuTitle, {
      font = { size = fontSize },
      color = workingColor
    }))
  end
end

function updateAllCrypto()
  for i, currency in ipairs(cryptocurrencies) do
    updateCrypto(currency, menusCrypto[i])
  end
end

function buildCryptoMenus()
  for i, currency in ipairs(cryptocurrencies) do
    menusCrypto[i] = hs.menubar.new()
    local setMenu = function()
      hs.urlevent.openURL('https://coinmarketcap.com/assets/' .. currency .. '/')
    end
    menusCrypto[i]:setClickCallback(setMenu)
    iconPathPrefix = script_path() .. 'images/'
    iconPath = iconPathPrefix .. 'bitcoin.pdf'
    if currency == 'bitcoin' then
      iconPath = iconPathPrefix .. 'bitcoin.pdf'
    elseif currency == 'ethereum' then
      iconPath = iconPathPrefix .. 'ethereum.pdf'
    end
    icon = hs.image.imageFromPath(iconPath)
    menusCrypto[i]:setIcon(icon:setSize({ w = fontSize, h = fontSize }))
  end
end

buildCryptoMenus()
updateTimerSet()
updateAllCrypto()

return obj