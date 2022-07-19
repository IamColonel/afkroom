ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('afk:reward')
AddEventHandler('afk:reward', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
	local _source = source
    local point = math.random(1, 10)
    local license = xPlayer.getIdentifier()
        TriggerClientEvent('esx:showAdvancedNotification', 'AFKROOM', '', 'Vous avez reçu vos :\n'..point..' ', "CHAR_DREYFUSS", 3)
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier=@identifier', {
            ['@identifier'] = license
        }, function(data)
            local poi = data[1].pb
            npoint = poi + point
    
            MySQL.Async.execute('UPDATE `users` SET `pb`=@point  WHERE identifier=@identifier', {
                ['@identifier'] = license,
                ['@point'] = npoint 
            }, function(rowsChange)
            end)
        end)
    end
end, false)
