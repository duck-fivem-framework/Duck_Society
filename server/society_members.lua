function DuckSocietyMembers()
    local self = {}
    self.__metas = { object = Config.MagicString.KeyStringMembers }

    self.id = nil
    self.societyId = nil
    self.roleId = nil
    self.playerId = nil

    self.setId = function(id) self.id = tonumber(id) end
    self.getId = function() return self.id end
    self.setSocietyId = function(societyId) self.societyId = tonumber(societyId) end
    self.getSocietyId = function() return self.societyId end
    self.setRoleId = function(roleId) self.roleId = tonumber(roleId) end
    self.getRoleId = function() return self.roleId end
    self.setPlayerId = function(playerId) self.playerId = tonumber(playerId) end
    self.getPlayerId = function() return self.playerId end

    self.loadFromDatabase = function(data)
        if data then
            self.setId(data.id)
            self.setSocietyId(data.societyId)
            self.setRoleId(data.roleId)
            self.setPlayerId(data.playerId)
        else
            print("Error: No data provided to load DuckSocietyMembers")
        end
    end

    self.getSociety = function()
        if not self.societyId then
            print("Error: Society ID is not set")
            return nil, 'Society ID is not set'
        end

        local society = societies[self.societyId]
        if not society then
            print("Error: Society not found")
            return nil, 'Society not found'
        end

        return society, 'Society retrieved successfully'
    end

    self.getRole = function()
        if not self.roleId then
            print("Error: Role ID is not set")
            return nil, 'Role ID is not set'
        end

        for _, role in pairs(societies[self.societyId].getRoles()) do
            if role.getId() == self.roleId then
                return role, 'Role retrieved successfully'
            end
        end

        return role, 'Role retrieved successfully'
    end

    self.setRole = function(role)
        if type(role) ~= 'table' or not role.__metas or role.__metas.object ~= Config.MagicString.KeyStringRoles then
            print("Error: Invalid role object")
            return false, 'Invalid role object'
        end

        self.setRoleId(role.getId())
        return true, 'Role set successfully'
    end

    self.setSociety = function(society)
        if type(society) ~= 'table' or not society.__metas or society.__metas.object ~= Config.MagicString.KeyStringSociety then
            print("Error: Invalid society object")
            return false, 'Invalid society object'
        end

        self.setSocietyId(society.getId())
        return true, 'Society set successfully'
    end

    self.getPlayer = function()
        if not self.playerId then
            print("Error: Player ID is not set")
            return nil, 'Player ID is not set'
        end

        local player = players[self.playerId]
        if not player then
            print("Error: Player not found")
            return nil, 'Player not found'
        end

        return player, 'Player retrieved successfully'
    end

    self.setPlayer = function(player)
        if type(player) ~= 'table' or not player.__metas or player.__metas.object ~= Config.MagicString.KeyStringPlayer then
            print("Error: Invalid player object")
            return false, 'Invalid player object'
        end

        self.setPlayerId(player.getId())
        return true, 'Player set successfully'
    end
    
    self.toString = function()
        return string.format("DuckSocietyMembers: { id: %d, societyId: %d, roleId: %d, playerId: %d }",
            self.getId(), self.getSocietyId(), self.getRoleId(), self.getPlayerId())
    end

    return self
end