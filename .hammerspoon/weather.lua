-- Weather

require 'common'

if file_exists('darksky_api_key.lua') then

  local apiKey = require 'darksky_api_key'
  local latitude = '41.9045500'
  local longitude = '-87.6283080'
  local updateInterval = 60 * 15

  if hs.location.get() ~= nil then
    loc = hs.location.get()
    latitude = loc.latitude
    longitude = loc.longitude
  end

  local menuWeather = hs.menubar.new()

  local weatherTimer = nil

  function weatherTimerSet()
    weatherTimer = hs.timer.doEvery(updateInterval, function()
      updateWeather()
    end)
  end

  function openDarkSky()
    hs.urlevent.openURLWithBundle('https://darksky.net/forecast/' .. latitude .. ',' .. longitude .. '/us12/en', hs.urlevent.getDefaultHandler('http'))
  end

  function getWeatherIcon(icon)
    iconLabel = '☁️'
    if icon == 'partly-cloudy-day' or icon == 'partly-cloudy-night' then
      iconLabel = '⛅️'
    elseif icon == 'snow' then
      iconLabel = '❄️'
    elseif icon == 'clear-day' then
      iconLabel = '☀️'
    elseif icon == 'clear-night' then
      iconLabel = '🌙'
    elseif icon == 'rain' or icon == 'sleet' then
      iconLabel = '🌧'
    elseif icon == 'fog' then
      iconLabel = '🌫'
    elseif icon == 'wind' then
      iconLabel = '💨'
    end
    return iconLabel
  end

  function updateWeather()
    status, data, headers = hs.http.get('https://api.darksky.net/forecast/' .. apiKey .. '/' .. latitude .. ',' .. longitude, {})
    if status == 200 then
      json = hs.json.decode(data)
      temperature = math.floor(json.currently.apparentTemperature)
      icon = json.currently.icon
      menuIconLabel = getWeatherIcon(icon)
      menuTable = {
        {
          title = 'darksky.net',
          fn = function() openDarkSky() end
        },
        {
          title = '-'
        }
      }
      for i = 1, 8 do
        hour = json.hourly.data[i]
        hourNumber = tonumber(os.date("%I", hour.time))
        hourLabel = hourNumber .. '' .. os.date("%p", hour.time):lower()
        if hourNumber < 10 then
          hourLabel = hourLabel .. ' '
        end
        table.insert(menuTable, {
          title = hourLabel .. "\t" .. getWeatherIcon(hour.icon) .. "\t" .. math.floor(hour.apparentTemperature) .. '°',
          fn = function() openDarkSky() end
        })
      end
      menuWeather:setTitle(menuIconLabel .. ' ' .. temperature .. '°')
      menuWeather:setMenu(menuTable)
    end
  end

  local setMenu = function()
    openDarkSky()
  end

  weatherTimerSet()
  updateWeather()

end
