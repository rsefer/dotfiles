-- Cryptocurrencies

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
        menu_item:setTitle(v.currency .. ' ' .. v.rates.USD)
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
  end
end

buildCryptoMenus()
cryptoTimerSet()
updateAllCrypto()
