Societies = {}
Identities = {}
Players = {}

for k,v in pairs(database.identities) do
  local identity = DuckIdentity()
  identity.loadFromDatabase(v)
  Identities[identity.getId()] = identity
end
for k,v in pairs(database.players) do
  local player = DuckPlayer()
  player.loadFromDatabase(v)
  Players[player.getId()] = player
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
  Societies[society.getId()] = society
end

for k,v in pairs(Societies) do
  v.generateEventHandler()
  Wait(1000)
end

for k,v in pairs(Societies) do
	TriggerEvent('duck:society:' .. v.getName() .. ':test')
 	Wait(1000)
end

for k,v in pairs(Players) do
  print(v.toString())
  Wait(1000)
end

local function createPlayerWithInfo(identifier, name)
    local identity = DuckIdentity()
    database.maxIdentityId = database.maxIdentityId + 1
    identity.setFirstname("Unknown")
    identity.setLastname("Unknown")
    identity.setDateOfBirth(os.date("%Y-%m-%d")) -- Set to current date for simplicity
    identity.setId(database.maxIdentityId) -- Assuming getNextId() is a method to get the next available ID

    Identities[identity.getId()] = identity
    print(string.format("Created new identity for player %s: %s", name, identity.toString()))

    -- Create a new DuckPlayer instance if the player does not exist
    local playerObject = DuckPlayer()
    database.maxPlayerId = database.maxPlayerId + 1

    playerObject.setId(database.maxPlayerId) -- Assuming getNextId() is a method to get the next available ID
    playerObject.setIdentifier(identifier)
    playerObject.setMoney(0)
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

        playerObject = createPlayerWithInfo(steamIdentifier, name)
    end

    
    playerObject.setOnline(true)
    playerObject.setSource(player) -- Set the source to the player itself

    StoreDatabase()
end



AddEventHandler("playerConnecting", OnPlayerConnecting)

function OnPlayerDropped(reason, resourceName, clientDropReason)
    local player = source
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

function onRessourceStop(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  StoreDatabase()
end
AddEventHandler('onResourceStop', onRessourceStop)


for _, playerId in ipairs(GetPlayers()) do
  local name = GetPlayerName(playerId)
  local steamIdentifier = nil
  local identifiers = GetPlayerIdentifiers(playerId)
  for _, v in pairs(identifiers) do
    if string.find(v, "steam") then
      steamIdentifier = v
      break
    end
  end
  if steamIdentifier then
    local playerObject = nil
    for _, v in pairs(Players) do
      if v.getIdentifier() == steamIdentifier then
        playerObject = v
        break
      end
    end

    if not playerObject then
      playerObject = createPlayerWithInfo(steamIdentifier)
    end

    playerObject.setOnline(true)
    playerObject.setSource(playerId) -- Set the source to the player itself

    print(string.format("Player %s with Steam ID %s is online.", name, steamIdentifier))
  else
    print(string.format("Player %s does not have a valid Steam ID.", name))
  end
  -- ('%s'):format('text') is same as string.format('%s', 'text)
end