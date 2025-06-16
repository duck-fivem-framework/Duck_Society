societies = {}
identities = {}
players = {}

for k,v in pairs(database.identities) do
  local identity = DuckIdentity()
  identity.loadFromDatabase(v)
  identities[identity.getId()] = identity
end
for k,v in pairs(database.players) do
  local player = DuckPlayer()
  player.loadFromDatabase(v)
  players[player.getId()] = player
end

for k,v in pairs(database.societies) do
  local society = DuckSociety()
  v.roles = {}
  v.members = {}
  if database.roles then
    for _, role in pairs(database.roles) do
      if role.societyId == v.id then
        table.insert(v.roles, role)
      end
    end
  end
  if database.members then
    for _, member in pairs(database.members) do
      if member.societyId == v.id then
        table.insert(v.members, member)
      end
    end
  end
  society.loadFromDatabase(v)
  societies[society.getId()] = society
  for _, member in pairs(society.getMembers()) do
    local player = players[member.getPlayerId()]
    if player then
      player.setSociety(society)
      player.setRole(member.getRole())
    else
      print("Error: Player with ID " .. member.getPlayerId() .. " not found for society " .. society.getName())
    end
  end
end

for k,v in pairs(societies) do
  v.generateEventHandler()
  Wait(1000)
end

for k,v in pairs(societies) do
	TriggerEvent('duck:society:' .. v.getName() .. ':test')
 	Wait(1000)
end

for k,v in pairs(players) do
  print(v.toString())
  Wait(1000)
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
    for _, v in pairs(players) do
        if v.getIdentifier() == steamIdentifier then
            playerObject = v
            break
        end
    end

    if not playerObject then
        -- Create a new DuckPlayer instance if the player does not exist

        local identity = DuckIdentity()
        database.maxIdentityId = database.maxIdentityId + 1
        identity.setFirstname("Unknown")
        identity.setLastname("Unknown")
        identity.setDateOfBirth(os.date("%Y-%m-%d")) -- Set to current date for simplicity
        identity.setId(database.maxIdentityId) -- Assuming getNextId() is a method to get the next available ID

        identities[identity.getId()] = identity
        print(string.format("Created new identity for player %s: %s", name, identity.toString()))

        -- Create a new DuckPlayer instance if the player does not exist
        playerObject = DuckPlayer()
        database.maxPlayerId = database.maxPlayerId + 1

        playerObject.setId(database.maxPlayerId) -- Assuming getNextId() is a method to get the next available ID
        playerObject.setIdentifier(steamIdentifier)
        playerObject.setMoney(0)
        playerObject.setIdentityId(nil) -- Set to nil initially
        playerObject.setSociety(nil) -- No society initially
        playerObject.setRole(nil) -- No role initially
        players[playerObject.getId()] = playerObject
    end

    
    playerObject.setOnline(true)
    playerObject.setSource(player) -- Set the source to the player itself

    storeDatabase()
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

function OnPlayerDropped(reason, resourceName, clientDropReason)
    local player = source
    local playerObject = nil
    for _, v in pairs(GetPlayerIdentifiers(player)) do
        if string.find(v, "steam") then
            playerObject = v
            break
        end
    end

    if playerObject then
        playerObject.setOnline(false)
        playerObject.setSource(nil) -- Clear the source when the player drops
        print(string.format("Player %s with ID %d has dropped. Reason: %s, Resource: %s, Client Drop Reason: %s",
            playerObject.getIdentifier(), playerObject.getId(), reason, resourceName, clientDropReason))
    else
        print(string.format("Player with ID %d has dropped but was not found in the players table.", player))
    end

    storeDatabase()
end

-- source is global here, don't add to function
AddEventHandler('playerDropped', OnPlayerDropped)

function onRessourceStop(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  storeDatabase()
end
AddEventHandler('onResourceStop', onRessourceStop)