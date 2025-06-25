function DuckSocietyMembers()
    local self = DuckClass(Config.MagicString.KeyStringMembers)

    self = __LoadId(self)
    self = __LoadSociety(self)
    self = __LoadSocietyRole(self)
    self = __LoadPlayer(self)

    self.loadFromDatabase = function(data)
        if data then
            self.setId(data.id)
            self.setSocietyId(data.societyId)
            self.setSocietyRoleId(data.roleId)
            self.setPlayerId(data.playerId)
        else
            print("Error: No data provided to load DuckSocietyMembers")
        end
    end

    self.toString = function()
        return string.format("DuckSocietyMembers: { id: %d, societyId: %d, roleId: %d, playerId: %d }",
            self.getId(), self.getSocietyId(), self.getSocietyRoleId(), self.getPlayerId())
    end

    self.storeInFile = function(f)
        f:write("        {\n")
        f:write("            id = " .. self.getId() .. ",\n")
        f:write("            societyId = " .. self.getSocietyId() .. ",\n")
        f:write("            roleId = " .. self.getSocietyRoleId() .. ",\n")
        f:write("            playerId = " .. self.getPlayerId() .. "\n")
        f:write("        },\n")
    end

    return self
end