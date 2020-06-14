CityData = {
    id = CityId,
    offset = 0
}

RegisterServerEvent('setRealTime')
AddEventHandler('setRealTime', function()
    TriggerEvent('setWeather')
    Wait(500)
    TriggerEvent('getTime', CityData.offset)
end)

RegisterServerEvent('setWeather')
AddEventHandler('setWeather', function ()
    local baseURL = 'https://api.openweathermap.org/data/2.5/weather?'
    local apiCall = baseURL..'id='..CityData.id..'&appid='..ApiKey
    PerformHttpRequest(apiCall, GetLocalWeather, 'GET')
end)

function GetLocalWeather(statusCode, response)
    if statusCode ~= 200 then
        return
    end
    local apiData = json.decode(response)
    local weatherId = apiData.weather[1].id
    CityData.offset = apiData.timezone
    SetWeatherFromId(weatherId)
end

function SetWeatherFromId(id)
    local weatherType = 'extrasunny'
    local rainLevel = -1.0
    local weatherId = tonumber(id)

    if weatherId >= 200 and weatherId <= 299 then
        weatherType = 'thunder'
        if weatherId == 200 then
            rainLevel = 0.1
        elseif weatherId == 201 then
            rainLevel = 0.5
        elseif weatherId == 202 then
            rainLevel = 0.9
        elseif weatherId >= 211 and weatherId <= 221 then
            rainLevel = 0.0
        else
            rainLevel = 0.3
        end
    end

    if weatherId >= 300 and weatherId <= 399 then
        weatherType = 'overcast'
    end

    if weatherId >= 500 and weatherId <= 599 then
        weatherType = 'rain'
        if weatherId == 500 then
            rainLevel = 0.1
        elseif weatherId == 501 then
            rainLevel = 0.3
        elseif weatherId == 502 then
            rainLevel = 0.6
        elseif weatherId == 503 then
            rainLevel = 0.9
        else
            rainLevel = 0.5
        end
    end

    if weatherId >= 600 and weatherId <= 699 then
        weatherType = 'snow'
    end

    if weatherId == 711 then
        weatherType = 'smog'
    end

    if weatherId == 741 then
        weatherType = 'foggy'
    end

    if weatherId >= 800 and weatherId <= 899 then
        if weatherId == 800 then
            weatherType = 'extrasunny'
        elseif weatherId == 801 then
            weatherType = 'clear'
        elseif weatherId == 802 or weatherId == 803 then
            weatherType = 'clouds'
        else
            weatherType = 'overcast'
        end
    end
   
    TriggerClientEvent('setClientWeather', -1, weatherType, rainLevel)
end

Citizen.CreateThread(function ()
    while true do
       Citizen.Wait(WeatherRequestDelay * 60000)
       TriggerEvent('setWeather')
    end
end)