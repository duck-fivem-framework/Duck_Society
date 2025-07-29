Players = {}

function LoadPlayers()
    for k,v in pairs(Database.players) do
        local player = DuckPlayer()
        player.loadFromDatabase(v)
        Players[player.getId()] = player
    end
end


function CreatePlayerWithInfo(identifier, name)
    local identity = DuckIdentity()
    Database.maxIdentityId = Database.maxIdentityId + 1
    identity.setFirstname("Unknown")
    identity.setLastname("Unknown")
    identity.setDateOfBirth(os.date("%Y-%m-%d")) -- Set to current date for simplicity
    identity.setId(Database.maxIdentityId) -- Assuming getNextId() is a method to get the next available ID

    Identities[identity.getId()] = identity
    print(string.format("Created new identity for player %s: %s", name, identity.toString()))

    -- Create a new DuckPlayer instance if the player does not exist
    local playerObject = DuckPlayer()
    Database.maxPlayerId = Database.maxPlayerId + 1

    playerObject.setId(Database.maxPlayerId) -- Assuming getNextId() is a method to get the next available ID
    playerObject.setIdentifier(identifier)
    playerObject.setIdentityId(identity.getId()) -- Set to nil initially
    Players[playerObject.getId()] = playerObject

    return playerObject
end

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local steamIdentifier
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()

    -- mandatory wait!
    Wait(0)

    deferrals.update(string.format("Hello %s. Your Steam ID is being checked.", name))

    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end

    -- mandatory wait!
    Wait(0)

    if not steamIdentifier then
        deferrals.done("You are not connected to Steam.")
    else
        deferrals.done()
    end

    -- Log the player connection
    print(string.format("Player %s with Steam ID %s is connecting.", name, steamIdentifier))
    local playerObject = nil
    for _, v in pairs(Players) do
        if v.getIdentifier() == steamIdentifier then
            playerObject = v
            break
        end
    end

    if not playerObject then
        -- Create a new DuckPlayer instance if the player does not exist
        playerObject = CreatePlayerWithInfo(steamIdentifier, name)
    end

    
    playerObject.setOnline(true)
    playerObject.setSource(player) -- Set the source to the player itself

    StoreDatabase()
end

RegisterNetEvent('requestLastCoords', function()
    local src = source
    local identifiers = GetPlayerIdentifiers(src)

    local steamIdentifier
    for key, value in pairs(identifiers) do
        if string.find(value, "steam") then
            steamIdentifier = value
            break
        end
    end
    if not steamIdentifier then
        print("No Steam identifier found for player " .. src)
        return
    end
    for key, value in pairs(Players) do
        if value.getIdentifier() == steamIdentifier then
            if value.getLocation() ~= nil then
                print(string.format("Player %d last known position: X: %.2f, Y: %.2f, Z: %.2f, Heading: %.2f",
                    value.getId(), value.getLocation().getX(), value.getLocation().getY(),
                    value.getLocation().getZ(), value.getLocation().getHeading()))
                TriggerClientEvent('teleportToLastCoords', source, value.getLocation().getX(), value.getLocation().getY(), value.getLocation().getZ(), value.getLocation().getHeading())
                else
                print("No last known position found for player " .. value.getId())
            end
            break
        end
    end
end)


AddEventHandler("playerConnecting", OnPlayerConnecting)

local function OnPlayerDropped(reason, resourceName, clientDropReason)
    local player = source

    local playerPed = GetPlayerPed(player)

    local playerObject = nil
    for _, v in pairs(GetPlayerIdentifiers(player)) do
        if string.find(v, "steam") then
            local steamIdentifier = v
            for _, p in pairs(Players) do
                if p.getIdentifier() == steamIdentifier then
                    playerObject = p
                    break
                end
            end
            break
        end
    end

    if playerObject then
        -- Vérifie que le ped existe encore
        if DoesEntityExist(playerPed) then
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)

            playerObject.setLocation(DuckLocation())

            playerObject.getLocation().setX(string.format("%.2f", coords.x))
            playerObject.getLocation().setY(string.format("%.2f", coords.y))
            playerObject.getLocation().setZ(string.format("%.2f", coords.z))
            playerObject.getLocation().setHeading(string.format("%.2f", heading))

            -- Log the last position of the player
            print(string.format("Dernière position de %d : X: %.2f, Y: %.2f, Z: %.2f, H: %.2f", 
                player, coords.x, coords.y, coords.z, heading))
        end

        playerObject.setOnline(false)
        playerObject.setSource(nil) -- Clear the source when the player drops
        print(string.format("Player %s with ID %d has dropped. Reason: %s, Resource: %s, Client Drop Reason: %s",
            playerObject.getIdentifier(), playerObject.getId(), reason, resourceName, clientDropReason))
    else
        print(string.format("Player with ID %d has dropped but was not found in the players table.", player))
    end

    StoreDatabase()
end

-- source is global here, don't add to function
AddEventHandler('playerDropped', OnPlayerDropped)