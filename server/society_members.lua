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

        local society = Societies[self.societyId]
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

        local society = self.getSociety()
        if not society then
            print("Error: Society not found")
            return nil, 'Society not found'
        end



        for _, role in pairs(self.getSociety().getRoles()) do
            if role.getId() == self.roleId then
                return role, 'Role retrieved successfully'
            end
        end

        print("Error: Role not found in society")
        return nil, 'Role not found in society'
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

        local player = Players[self.playerId]
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


RegisterCommand("getSocietyMembers", function(source, args, rawCommand)
    local societyId = tonumber(args[1])
    if not societyId then
        print("Usage: /getSocietyMembers <societyId>")
        return
    end

    local society = Societies[societyId]
    if not society then
        print("Society with ID " .. societyId .. " not found.")
        return
    end

    local members = society.getMembers()
    if not members or #members == 0 then
        print("No members found for society " .. society.getName())
        return
    end

    for _, member in pairs(members) do
        local player = Players[member.getPlayerId()]
        if player then
            print(player.toString())
        else
            print("Error: Player with ID " .. member.getPlayerId() .. " not found for society " .. society.getName())
        end
    end
end, false)