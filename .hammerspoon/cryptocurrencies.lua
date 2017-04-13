-- Cryptocurrencies

---------------------------
--- Start Configuration ---
---------------------------

-- Browser
-- Chrome: com.google.Chrome
-- Safari: com.apple.Safari
-- Firefox: org.mozilla.firefox
local browserBundle = 'com.google.Chrome'

-- Cryptocurrencies to display (likely in reverse order)
-- Bitcoin: BTC
-- Ethereum: ETH
-- Litecoin: LTC
local cryptocurrencies = {'BTC', 'ETH'}
local localcurrency = 'USD'

-- Update interval (in seconds)
local updateInterval = 60 * 5

-- Aesthetics
local useColors = false
local useIcons = true
local fontSize = 14.0

-------------------------
--- End Configuration ---
-------------------------

local lastValues = {}
local menus = {}
local menuBTC = nil
local menuETH = nil
local cryptoTimer = nil

function cryptoTimerSet()
  cryptoTimer = hs.timer.doEvery(updateInterval, function()
    updateAllCrypto()
  end)
end

function updateCrypto(currency, menu_item)
  status, data, headers = hs.http.get('https://api.coinbase.com/v2/exchange-rates?currency=' .. currency, {})
  if status == 200 then
    for k,v in pairs(hs.json.decode(data)) do
      if k == 'data' and v and v.rates and v.rates.USD then
        workingColor = nil
        currentValue = tonumber(v.rates.USD)
        if useColors then
          if lastValues[v.currency] and currentValue > lastValues[v.currency] then
            workingColor = { green = 1 }
          elseif lastValues[v.currency] and currentValue < lastValues[v.currency] then
            workingColor = { red = 1 }
          end
        end
        menuTitle = ' ' .. currentValue
        if useIcons == false then
          menuTitle = v.currency .. menuTitle
        end
        menu_item:setTitle(hs.styledtext.new(menuTitle, {
          font = { size = fontSize },
          color = workingColor
        }))
        lastValues[v.currency] = currentValue
      end
    end
  end
end

function updateAllCrypto()
  for i, currency in ipairs(cryptocurrencies) do
    updateCrypto(currency, menus[i])
  end
end

function setCurrencyMenuClick(currency)
  hs.urlevent.openURLWithBundle('https://www.gdax.com/trade/' .. currency .. '-' .. localcurrency, browserBundle)
end

function buildCryptoMenus()
  for i, currency in ipairs(cryptocurrencies) do
    menus[i] = hs.menubar.new()
    local setMenu = function()
      hs.urlevent.openURLWithBundle('https://www.gdax.com/trade/' .. currency .. '-' .. localcurrency, browserBundle)
    end
    menus[i]:setClickCallback(setMenu)
    if useIcons then
      iconPath = 'images/bitcoin.pdf'
      if currency == 'BTC' then
        iconPath = 'images/bitcoin.pdf'
      elseif currency == 'ETH' then
        iconPath = 'images/ethereum.pdf'
      elseif currency == 'LTC' then
        iconPath = 'images/litecoin.pdf'
      end
      icon = hs.image.imageFromPath(iconPath)
      menus[i]:setIcon(icon:setSize({ w = fontSize, h = fontSize }))
    end
  end
end

buildCryptoMenus()
cryptoTimerSet()
updateAllCrypto()
