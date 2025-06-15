function createDuckPlayer()
    local self = {}
    self.__metas = { object = Config.MagicString.KeyStringPlayers }

    self.id = nil
    self.identifier = nil

    self.identityId = nil
    self.society = nil
    self.role = nil

    self.money = 0

    self.setId = function(id) self.id = tonumber(id) end
    self.getId = function() return self.id end
    self.setIdentifier = function(identifier) self.identifier = identifier end
    self.getIdentifier = function() return self.identifier end
    self.setMoney = function(money) self.money = tonumber(money) end
    self.getMoney = function() return self.money end

    self.loadFromDatabase = function(data)
        if data then
            self.setId(data.id)
            self.setName(data.name)
            self.setIdentifier(data.identifier)
            self.setMoney(data.money or 0) -- Default to 0 if money is not provided
        else
            print("Error: No data provided to load DuckPlayers")
        end
    end


    self.getSociety = function()
        if not self.society then
            print("Error: Society is not set")
            return nil, 'Society is not set'
        end

        return self.society, 'Society retrieved successfully'
    end

    self.getRole = function()
        if not self.role then
            print("Error: Role is not set")
            return nil, 'Role is not set'
        end

        return self.role, 'Role retrieved successfully'
    end

    self.setSociety = function(society)
        if not society or type(society) ~= 'table' then
            print("Error: Invalid society provided")
            return false, 'Invalid society provided'
        end

        if not society.__metas or society.__metas.object ~= Config.MagicString.KeyStringSociety then
            return false, 'Invalid role object'
        end

        self.society = society
        return true, 'Society set successfully'
    end

    self.setRole = function(role)
        if not role or type(role) ~= 'table' then
            print("Error: Invalid role provided")
            return false, 'Invalid role provided'
        end

        if not role.__metas or role.__metas.object ~= Config.MagicString.KeyStringRoles then
            return false, 'Invalid role object'
        end

        if not self.society or (self.society and role.getSocietyId() ~= self.society.getId()) then
            return false, 'Role does not belong to the player\'s society'
        end

        self.role = role
        return true, 'Role set successfully'
    end

    self.getIdentity = function()
        if not self.identityId then
            print("Error: Identity ID is not set")
            return nil, 'Identity ID is not set'
        end

        local identity = identities[self.identityId]
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

    return self
end