-- Quand le joueur spawn, on demande sa dernière position
AddEventHandler('playerSpawned', function(spawn)
    Citizen.Wait(1000) -- Attendre un peu pour s'assurer que le joueur est bien spawn
    TriggerServerEvent('requestLastCoords')
end)

-- Réception de la position et téléportation
RegisterNetEvent('teleportToLastCoords', function(x, y, z, heading)
    CreateThread(function()
        -- Attend que le joueur ait bien un ped valide
        while not DoesEntityExist(PlayerPedId()) or IsEntityDead(PlayerPedId()) do
            Wait(100)
        end

        -- Petit délai pour éviter les crashs au spawn
        Wait(500)

        if x and y and z then
            SetEntityCoords(PlayerPedId(), x + 0.0, y + 0.0, z + 0.0, false, false, false, true)
            SetEntityHeading(PlayerPedId(), heading or 0.0)
            print(("Téléporté à la dernière position: %.2f %.2f %.2f"):format(x, y, z))
        else
            print("Aucune dernière position trouvée, spawn par défaut.")
        end
    end)
end)