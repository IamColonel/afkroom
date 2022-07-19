local ESX

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

local function createBlip()
    local blip <const> = AddBlipForCoord(Config.blipPosition)

    SetBlipSprite(blip, 197)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 27)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Salle des AFK")
    EndTextCommandSetBlipName(blip)
end

local function doAfkCheck()
    local coords <const> = GetEntityCoords(PlayerPedId())
    local dist <const> = #(coords - Config.entrepot.position)

    if (dist < 40) then
        TriggerServerEvent('afk:reward')
    end
end

local function afkMenu()
    local menu<const> = RageUI.CreateMenu("AFK", "Vous êtes AFK")

    menu.Closable = false
    RageUI.Visible(menu, not RageUI.Visible(menu))

    while (menu) do
        Wait(0)
        RageUI.IsVisible(menu, true, true, true, function()
            RageUI.Separator("Vous ~y~gagnez entre")
            RageUI.Separator("~r~1 ~s~et ~r~8 ~s~points boutique")
            RageUI.Separator("Toutes les ~r~15 minutes ~s~!")
            RageUI.ButtonWithStyle("~r~Retourner en ville !", nil, {}, true, function(_, _, selected)
                if (selected) then
                    SetEntityCoords(PlayerPedId(), Config.entrepot.sortie)
                    RageUI.CloseAll()
                end
            end)
        end, function()
        end)
    end
end

local function enterAfk()
    local menu <const> = RageUI.CreateMenu("AFK", "Dortoir")

    RageUI.Visible(menu, not RageUI.Visible(menu))

    while (menu) do
        Wait(0)
        RageUI.IsVisible(menu, true, true, true, function()
            RageUI.Separator("Entrer dans le Dortoir")
            RageUI.ButtonWithStyle("~r~Aller dormir !", nil, {}, true, function(_, _, selected)
                if (selected) then
                    SetEntityCoords(PlayerPedId(), Config.entrepot.position)
                    RageUI.CloseAll()
                    afkMenu()
                end
            end)
        end, function()
        end)
    end
end

RegisterCommand("afk", function()
    enterAfk()
end)

CreateThread(function()
    while (true) do
        Wait(Config.interval)
        doAfkCheck()
    end
end)

CreateThread(function()
    while (true) do
        Wait(0)
        local coords <const> = GetEntityCoords(PlayerPedId())
        local dist <const> = #(coords - Config.entrepot.sortie)

        if (dist <= 1.0) then
            ExecuteCommand("afk")
            ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour entrer")
            if (IsControlJustPressed(0, 51)) then
                enterAfk()
            end
        end
    end
end)

createBlip()