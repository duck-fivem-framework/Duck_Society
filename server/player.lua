function DuckPlayer()
    local self = {}
    self.__metas = { object = Config.MagicString.KeyStringPlayers }

    self.id = nil
    self.identifier = nil

    self.identityId = nil

    self.money = 0
    self.online = false
    self.source = nil -- This will hold the source of the player, if applicable

    self.setId = function(id) self.id = tonumber(id) end
    self.getId = function() return self.id end
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

    return self
end

function LoadPlayers()
    for k,v in pairs(Database.players) do
        local player = DuckPlayer()
        player.loadFromDatabase(v)
        Players[player.getId()] = player
    end
end