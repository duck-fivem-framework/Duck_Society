SocietyMembers = {}

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

function LoadSocietyMembers()
    for k,v in pairs(Database.members) do
        local member = DuckSocietyMembers()
        member.loadFromDatabase(v)
        SocietyMembers[member.getId()] = member
    end
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


RegisterCommand("addSocietyMember", function(source, args, rawCommand)
    local societyId = tonumber(args[1])
    local playerId = tonumber(args[2])

    if not societyId or not playerId then
        print("Usage: /addSocietyMember <societyId> <playerId>")
        return
    end

    local society = Societies[societyId]
    if not society then
        print("Society with ID " .. societyId .. " not found.")
        return
    end

    local player = Players[playerId]
    if not player then
        print("Player with ID " .. playerId .. " not found.")
        return
    end

    local hireResult, hireMessage = society.hirePlayer(player)
    
    if not hireResult then
        print("Error hiring player: " .. hireMessage)
        return
    end

end, false)

RegisterCommand("removeSocietyMember", function(source, args, rawCommand)
    local societyId = tonumber(args[1])
    local playerId = tonumber(args[2])

    if not societyId or not playerId then
        print("Usage: /removeSocietyMember <societyId> <playerId>")
        return
    end

    local society = Societies[societyId]
    if not society then
        print("Society with ID " .. societyId .. " not found.")
        return
    end

    local member = society.getMemberByPlayerId(playerId)
    if not member then
        print("Member with Player ID " .. playerId .. " not found in society " .. society.getName())
        return
    end

    local success, message = society.firePlayer(member)
    if not success then
        print("Error removing member: " .. message)
        return
    end

end, false)

RegisterCommand("setSocietyRole", function(source, args, rawCommand)
    local societyId = tonumber(args[1])
    local playerId = tonumber(args[2])
    local roleId = tonumber(args[3])

    if not societyId or not playerId or not roleId then
        print("Usage: /setSocietyRole <societyId> <playerId> <roleId>")
        return
    end

    local society = Societies[societyId]
    if not society then
        print("Society with ID " .. societyId .. " not found.")
        return
    end

    local member = society.getMemberByPlayerId(playerId)
    if not member then
        print("Member with Player ID " .. playerId .. " not found in society " .. society.getName())
        return
    end

    local role = society.getRoleById(roleId)
    if not role then
        print("Role with ID " .. roleId .. " not found in society " .. society.getName())
        return
    end

    member.setRole(role)

end, false)