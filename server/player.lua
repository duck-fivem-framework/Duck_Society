function DuckPlayer()
    local self = {}
    self.__metas = { object = Config.MagicString.KeyStringPlayers }

    self.identifier = nil
    self.identityId = nil

    self.money = 0
    self.online = false
    self.source = nil -- This will hold the source of the player, if applicable

    self = __LoadId(self)
    
    self.setIdentifier = function(identifier) self.identifier = identifier end
    self.getIdentifier = function() return self.identifier end
    self.setMoney = function(money) self.money = tonumber(money) end
    self.getMoney = function() return self.money end
    self.setOnline = function(online) self.online = online end
    self.isOnline = function() return self.online end
    self.setSource = function(source) self.source = source end
    self.getSource = function() return self.source end
    self.getIdentityId = function() return self.identityId end
    self.setIdentityId = function(identityId) self.identityId = tonumber(identityId) end


    self.loadFromDatabase = function(data)
        if data then
            self.setId(data.id)
            self.setIdentifier(data.identifier)
            if data.identityId ~= nil then
                local identity = Identities[data.identityId]
                if identity then
                    self.setIdentity(identity)
                else
                    print("Error: Identity not found for ID " .. tostring(data.identityId))
                end
            end
            self.setMoney(data.money or 0) -- Default to 0 if money is not provided
        else
            print("Error: No data provided to load DuckPlayers")
        end
    end


    self.getIdentity = function()
        if not self.identityId then
            print("Error: Identity ID is not set")
            return nil, 'Identity ID is not set'
        end

        local identity = Identities[self.identityId]
        if not identity then
            print("Error: Identity not found")
            return nil, 'Identity not found'
        end

        return identity, 'Identity retrieved successfully'
    end

    self.setIdentity = function(identity)
        if not identity or type(identity) ~= 'table' then
            print("Error: Invalid identity provided")
            return false, 'Invalid identity provided'
        end

        if not identity.__metas or identity.__metas.object ~= Config.MagicString.KeyStringIdentity then
            return false, 'Invalid identity object'
        end

        self.identityId = identity.getId()
        return true, 'Identity set successfully'
    end

    self.toString = function()
        return string.format("DuckPlayer: { id: %d, identifier: '%s', money: %d, identity: %s}",
            self.getId(), self.getIdentifier(), self.getMoney(),
            self.identityId and self.getIdentity().getFullName() or 'nil')
    end

    self.addMoney = function(amount)
        if type(amount) ~= 'number' then
            print("Error: Amount must be a number")
            return false, 'Amount must be a number'
        end
        local newMoney = self.getMoney() + amount < 0
        if newMoney < 0 then
            self.setMoney(0)
            return true, 'Money cannot be negative, set to 0'
        end
        self.setMoney(self.getMoney() + amount)
        return true, 'Money added successfully'
    end

    self.removeMoney = function(amount)
        if type(amount) ~= 'number' then
            print("Error: Amount must be a number")
            return false, 'Amount must be a number'
        end
        local newMoney = self.getMoney() - amount < 0
        if newMoney < 0 then
            self.setMoney(0)
            return true, 'Money cannot be negative, set to 0'
        end

        if newMoney > self.getMoney() then
            print("Error: Not enough money to remove")
            return false, 'Not enough money to remove'
        end
        
        self.setMoney(self.getMoney() - amount)
        return true, 'Money removed successfully'
    end

    return self
end

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

        playerObject = CreatePlayerWithInfo(steamIdentifier, name)
    end

    
    playerObject.setOnline(true)
    playerObject.setSource(player) -- Set the source to the player itself

    StoreDatabase()
end



AddEventHandler("playerConnecting", OnPlayerConnecting)

local function OnPlayerDropped(reason, resourceName, clientDropReason)
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