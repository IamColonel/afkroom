local ESX

-- Linter fix
local MySQL = MySQL or {}

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

RegisterNetEvent("afk:reward", function()
    local serverId <const> = source
    local xPlayer <const> = ESX.GetPlayerFromId(serverId)

    if (xPlayer) then
        local point <const> = math.random(1, 10)
        local license <const> = xPlayer.getIdentifier()

        TriggerClientEvent("esx:showAdvancedNotification",
                serverId,
                "AFKROOM",
                "",
                ("Vous avez reçu vos :\n %s"):format(point),
                "CHAR_DREYFUSS",
                3
        )

        MySQL.Async.execute("UPDATE users SET pb = pb + 1 WHERE identifier = @identifier", {
            ['@identifier'] = license
        })
    end
end)
