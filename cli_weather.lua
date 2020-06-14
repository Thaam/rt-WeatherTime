AddEventHandler('onClientMapStart', function()
    TriggerServerEvent('setRealTime')
end)

RegisterNetEvent('setClientWeather')
AddEventHandler('setClientWeather', function (weatherType, rainLevel)
    SetWeatherType(weatherType, rainLevel)
end)

function SetWeatherType(weatherType, rainLevel)
    local transitionTime = 120.0
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeOverTime(weatherType, transitionTime)
    SetWeatherTypeOverTimePersist(weatherType, transitionTime)
    SetWeatherTypePersist(weatherType)
    SetWeatherTypeNowPersist(weatherType)
    SetWeatherTypeNow(weatherType)
    SetOverrideWeather(weatherType)
    SetRainFxIntensity(rainLevel)
end