-- Finance

---------------------------
--- Start Configuration ---
---------------------------

-- Browser
-- Chrome: com.google.Chrome
-- Safari: com.apple.Safari
-- Firefox: org.mozilla.firefox
local browserBundle = 'com.google.Chrome'

-- Equities to display (likely in reverse order)
local equities = {'VTI'}

-- Cryptocurrencies to display (likely in reverse order)
-- Bitcoin: BTC
-- Ethereum: ETH
-- Litecoin: LTC
-- Golem: GNT
local cryptocurrencies = {'GNT', 'ETH'}
local localcurrency = 'USD'

-- Update interval (in seconds)
local updateInterval = 60 * 5

-- Aesthetics
local useColors = false
local useIcons = true
local fontSize = 14.0

-- Coinbase
local cbAPIVersion = '2017-04-08'
local showPercentageChange = false

-------------------------
--- End Configuration ---
-------------------------

require 'common'

local lastValues = {}
local menusEquity = {}
local menusCrypto = {}
local updateTimer = nil

function updateTimerSet()
  updateTimer = hs.timer.doEvery(updateInterval, function()
    updateAllEquities()
    updateAllCrypto()
  end)
end

function updateEquity(symbol, menu_item)
  status, data, headers = hs.http.get("https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22" .. symbol .. "%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys", {})
  if status == 200 then
    for k, v in pairs(hs.json.decode(data)) do
      if k == 'query' and v and v.results and v.results.quote then
        menuTitleString = v.results.quote.ChangeinPercent
        break
      end
    end
    menuTitle = symbol .. ' ' .. menuTitleString
    menu_item:setTitle(hs.styledtext.new(menuTitle, {
      font = { size = fontSize },
      color = workingColor
    }))
  end
end

function updateCrypto(currency, menu_item)
  if currency == 'GNT' then
    status, data, headers = hs.http.get('https://api.coinmarketcap.com/v1/ticker/golem-network-tokens/?convert=' .. localcurrency, {})
    if status == 200 then
      for k, v in pairs(hs.json.decode(data)) do
        for k2, v2 in pairs(v) do
          if k2 == 'price_usd' then
            menuTitleString = math.floor(v2 * 1000) / 1000
          end
        end
      end
      menuTitle = ' ' .. menuTitleString
      if useIcons == false then
        menuTitle = currency .. menuTitle
      end
      menu_item:setTitle(hs.styledtext.new(menuTitle, {
        font = { size = fontSize },
        color = workingColor
      }))
      lastValues[currency] = currentValue
    end
  else
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
          menuTitleString = currentValue

          if showPercentageChange then
            yesterday = os.date("%Y-%m-%d", os.time() - 24 * 60 * 60)
            cstatus, cdata, cheaders = hs.http.get('https://api.coinbase.com/v2/prices/' .. currency .. '-USD/spot?date=' .. yesterday, { ['CB-VERSION'] = cbAPIVersion })
            if cstatus == 200 then
              for ck,cv in pairs(hs.json.decode(cdata)) do
                if ck == 'data' and cv and cv.amount then
                  difference = tonumber(cv.amount) / tonumber(currentValue)
                  percentage = math.floor((difference - 1) * 10000) / 100
                  if percentage >= 0 then
                    percentage = '+' .. percentage
                  end
                  menuTitleString = menuTitleString .. ' ' .. '(' .. percentage .. '%)'
                end
              end
            end
          end

          menuTitle = ' ' .. menuTitleString
          if useIcons == false then
            menuTitle = v.currency .. menuTitle
          end
          menu_item:setTitle(hs.styledtext.new(menuTitle, {
            font = { size = fontSize },
            color = workingColor
          }))
          lastValues[v.currency] = currentValue
          break
        end
      end
    end
  end
end

function updateAllEquities()
  for i, symbol in ipairs(equities) do
    updateEquity(symbol, menusEquity[i])
  end
end

function updateAllCrypto()
  for i, currency in ipairs(cryptocurrencies) do
    updateCrypto(currency, menusCrypto[i])
  end
end

function buildEquityMenus()
  for i, symbol in ipairs(equities) do
    menusEquity[i] = hs.menubar.new()
    local setMenu = function()
      urlString = 'https://invest.ameritrade.com/grid/p/site#r=jPage/https://research.ameritrade.com/grid/wwws/research/stocks/summary?symbol=' .. symbol
      hs.urlevent.openURLWithBundle(urlString, browserBundle)
    end
    menusEquity[i]:setClickCallback(setMenu)
  end
end

function buildCryptoMenus()
  for i, currency in ipairs(cryptocurrencies) do
    menusCrypto[i] = hs.menubar.new()
    local setMenu = function()
      urlString = ''
      if currency == 'GNT' then
        urlString = 'https://coinmarketcap.com/assets/golem-network-tokens/'
      else
        urlString = 'https://www.gdax.com/trade/' .. currency .. '-' .. localcurrency
      end
      hs.urlevent.openURLWithBundle(urlString, browserBundle)
    end
    menusCrypto[i]:setClickCallback(setMenu)
    if useIcons then
      iconPath = 'images/bitcoin.pdf'
      if currency == 'BTC' then
        iconPath = 'images/bitcoin.pdf'
      elseif currency == 'ETH' then
        iconPath = 'images/ethereum.pdf'
      elseif currency == 'GNT' then
        iconPath = 'images/golem.pdf'
      elseif currency == 'LTC' then
        iconPath = 'images/litecoin.pdf'
      end
      icon = hs.image.imageFromPath(iconPath)
      menusCrypto[i]:setIcon(icon:setSize({ w = fontSize, h = fontSize }))
    end
  end
end

buildEquityMenus()
buildCryptoMenus()
updateTimerSet()
updateAllEquities()
updateAllCrypto()
