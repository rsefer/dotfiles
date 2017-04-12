-- Cryptocurrencies

local browserBundle = 'com.google.Chrome'
-- Chrome: com.google.Chrome
-- Safari: com.apple.Safari
-- Firefox: org.mozilla.firefox

local updateTime = 5 -- seconds

local menuBTC = nil
local menuETH = nil
local cryptoTimer = nil

function cryptoTimerSet()
  cryptoTimer = hs.timer.doEvery(updateTime, function()
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
  updateCrypto('BTC', menuBTC)
  updateCrypto('ETH', menuETH)
end

function openBTC()
  hs.urlevent.openURLWithBundle('https://www.gdax.com/trade/BTC-USD', browserBundle)
end

function openETH()
  hs.urlevent.openURLWithBundle('https://www.gdax.com/trade/ETH-USD', browserBundle)
end

function loadCryptoMenus()
  menuBTC = hs.menubar.new():setClickCallback(openBTC)
  menuETH = hs.menubar.new():setClickCallback(openETH)
end

loadCryptoMenus()
cryptoTimerSet()
updateAllCrypto()
