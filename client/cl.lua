ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)


function checkPlayerJob()
    local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
    local dist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Config.entrepot.position.x, Config.entrepot.position.y, Config.entrepot.position.z)
                if dist < 40 then
                    TriggerServerEvent('afk:reward')
                    -- ESX.ShowNotification("OK")
                end
end

Citizen.CreateThread(function()   
    while true do
        Wait(Config.Time)
        checkPlayerJob()
    end

end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.entrepot.sortie.x, Config.entrepot.sortie.y, Config.entrepot.sortie.z)

            if dist <= 1.0 then
                ExecuteCommand("afk")
                ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour entrer")
                if IsControlJustPressed(0,51) then
                    entrerafk()  
            end
        end
    end
end)

local pos = vector3(875.89,-1576.85,30.81)
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(pos)

	SetBlipSprite (blip, 197)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.9)
	SetBlipColour (blip, 27)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Salle des AFK')
	EndTextCommandSetBlipName(blip)
end)

function entrerafk()
    local menu = RageUI.CreateMenu("AFK", "Dortoir")
    RageUI.Visible(menu, not RageUI.Visible(menu))
    while menu do
        Citizen.Wait(0)
        RageUI.IsVisible(menu, true, true, true, function()
            RageUI.Separator("Entrer dans le Dortoir")
            RageUI.ButtonWithStyle("~r~Aller dormir !", nil, {},true, function(_,_,s)
					if s then
						SetEntityCoords(PlayerPedId(), Config.entrepot.position.x, Config.entrepot.position.y, Config.entrepot.position.z)
                        RageUI.CloseAll()
                        menuafk()
					end
                end)
        end, function()
            end)
end
-- if not RageUI.Visible(menu) then
--     menu=RMenu:DeleteType("Titre", true)
-- end
end

function menuafk()
    local menu = RageUI.CreateMenu("AFK", "Vous êtes AFK")
    menu.Closable = false
    RageUI.Visible(menu, not RageUI.Visible(menu))
    while menu do
        Citizen.Wait(0)
        RageUI.IsVisible(menu, true, true, true, function()
            RageUI.Separator("Vous ~y~gagnez entre")
            RageUI.Separator("~r~1 ~s~et ~r~8 ~s~points boutique")
            RageUI.Separator("Toutes les ~r~15 minutes ~s~!")
            RageUI.ButtonWithStyle("~r~Retourner en ville !", nil, {},true, function(_,_,s)
					if s then
						SetEntityCoords(PlayerPedId(), Config.entrepot.sortie.x, Config.entrepot.sortie.y, Config.entrepot.sortie.z)
                        RageUI.CloseAll()
					end
				end)
        
        
        end, function()
            end)
end
-- if not RageUI.Visible(menu) then
--     menu=RMenu:DeleteType("Titre", true)
-- end
end

RegisterCommand("afk", function() 
    entrerafk()
  end)