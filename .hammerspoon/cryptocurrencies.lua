-- Cryptocurrencies
local browserBundle = 'com.google.Chrome' -- change for Safari, Firefox, etc.
local updateTime = 60

local menuBTC = nil
local menuETH = nil
local cryptoTimer = nil

function cryptoTimerSet()
  cryptoTimer = hs.timer.doEvery(updateTime, function()
    updateAllCrypto()
  end)
end

function updateCrypto(currency, menu_item)
  hs.http.asyncGet(
    'https://api.coinbase.com/v2/exchange-rates?currency=' .. currency,
    {},
    function(http_code, response)
      if http_code == 200 then
        for k,v in pairs(hs.json.decode(response)) do
          if k == 'data' and v and v.rates then
            for a,b in pairs(v.rates) do
              if a == 'USD' then
                menu_item:setTitle(v.currency .. ' ' .. b)
              end
            end
          end
        end
      end
    end
  )
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
