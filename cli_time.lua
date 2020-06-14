local year
local month
local serverDay = {d = 0}
local serverTime = {
	h = 0,
	m = 0,
	s = 0
}

RegisterNetEvent('setTime')
AddEventHandler('setTime', function(year, month, wday, hour, minute, second)
	local timer = GetGameTimer()

	serverDay.d = wday + 1
	serverTime = {h = hour, m = minute, s = second}
	SetClockDate(serverDay.d, month, year)

	Citizen.CreateThread(function()
		while true do
			Wait(1)
			local currentTimer = GetGameTimer()
			if (currentTimer - timer) >= 1000 then
				second = second + 1
				if second > 59 then
					second = 0
					minute = minute + 1
				end
				if minute > 59 then
					minute = 0
					hour = hour + 1
				end
				if hour > 23 then
					hour = 0
					wday = wday + 1
				end
				if wday > 6 then
					wday = 0
				end
				serverTime.s = second
				serverTime.m = minute
				serverTime.h = hour
				serverDay.d = wday + 1
				timer = currentTimer
			end
		end
	end)
end)

Citizen.CreateThread(function()
	local gameSecond = math.floor(GetMillisecondsPerGameMinute() / 60)
	while true do
		Wait(gameSecond)
		SetClockDate(serverDay.d, month, year)
		NetworkOverrideClockTime(serverTime.h, serverTime.m, serverTime.s)
	end
end)