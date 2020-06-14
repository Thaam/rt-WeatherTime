RegisterNetEvent('getTime')
AddEventHandler('getTime', function(timeOffset)
        local date = os.date('*t')
        date = os.date('!*t', os.time(date) + timeOffset)
        local year = date['year']
        local month = date['month']
        local wday = date['wday']
        local hour = date['hour']
        local minute = date['min']
        local second = date['sec']     
        TriggerClientEvent('setTime', -1, year, month, wday, hour, minute, second)
end)
