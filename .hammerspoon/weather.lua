-- Weather

function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

if file_exists('darksky_api_key.lua') then

  local apiKey = require 'darksky_api_key'
  local latitude = '41.9045500'
  local longitude = '-87.6283080'
  local updateInterval = 60 * 15

  local menuWeather = hs.menubar.new()

  local weatherTimer = nil

  function weatherTimerSet()
    weatherTimer = hs.timer.doEvery(updateInterval, function()
      updateWeather()
    end)
  end

  function updateWeather()
    status, data, headers = hs.http.get('https://api.darksky.net/forecast/' .. apiKey .. '/' .. latitude .. ',' .. longitude, {})
    if status == 200 then
      json = hs.json.decode(data)
      temperature = math.floor(json.currently.temperature)
      iconLabel = '☁️'
      icon = json.currently.icon
      if icon == 'partly-cloudy-day' or icon == 'partly-cloudy-night' then
        iconLabel = '🌥'
      elseif icon == 'snow' then
        iconLabel = '❄️'
      elseif icon == 'clear-day' then
        iconLabel = '☀️'
      elseif icon == 'clear-night' then
        iconLabel = '🌙'
      elseif icon == 'rain' or icon == 'sleet' then
        iconLabel = '🌧️'
      elseif icon == 'fog' then
        iconLabel = '🌫️'
      elseif icon == 'wind' then
        iconLabel = '🌬️'
      end
      menuWeather:setTitle(iconLabel .. ' ' .. temperature .. '°')
    end
  end

  local setMenu = function()
    hs.urlevent.openURLWithBundle('https://darksky.net/forecast/' .. latitude .. ',' .. longitude .. '/us12/en', 'com.google.Chrome')
  end

  menuWeather:setClickCallback(setMenu)
  weatherTimerSet()
  updateWeather()

end
