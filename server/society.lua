function DuckSociety()
  local self = {}
  self.__metas = { object = Config.MagicString.KeyStringSociety }

  self.id = nil
  self.name = nil
  self.label = nil
  self.roles = {}
  self.members = {}

  self.setId = function(id) self.id = tonumber(id) end
  self.getId = function() return self.id end
  
  self.setName = function(name) self.name = string.lower(name) end
  self.getName = function() return self.name end
  
  self.setLabel = function(label) self.label = label end
  self.getLabel = function() return self.label end
    
  self.handlerTest = function()
    print(self.toString())
    print('----- Roles -----')
    for _, role in pairs(self.getRoles()) do
      print(role.toString())
    end
    print('----- Members -----')
    for _, member in pairs(self.getMembers()) do
      print(member.toString())
    end
  end

  self.generateEventHandler = function()
    RegisterNetEvent(self.getFullEventName('test'))
    AddEventHandler(self.getFullEventName('test'), self.handlerTest)
  end


  self.getEventName = function()
    return 'duck:society:' .. self.getName() .. ':'
  end

  self.getFullEventName = function(eventName)
    return self.getEventName() .. eventName
  end

  self.loadFromDatabase = function(data)
    if data then
      self.setId(data.id)
      self.setName(data.name)
      self.setLabel(data.label)
    else
      print("Error: No data provided to load DuckSociety")
    end
  end

  self.checkRoleCompatibility = function(role)
    if type(role) ~= 'table' then
      return false, 'Role must be a table'
    end

    if not role.__metas or role.__metas.object ~= Config.MagicString.DuckSocietyRoles then
      return false, 'Invalid role object'
    end

    if role.getSocietyId() ~= self.getId() then
      return false, 'Role does not belong to this society'
    end

    return true, 'Role is compatible with this society'
  end

  self.getRoles = function()
    return self.roles
  end

  self.addRole = function(role)
    local compatibility, errorMessage = self.checkRoleCompatibility(role)
    if not compatibility then
      return false, errorMessage
    end

    if self.roles[role.getId()] then
      return false, 'Role already exists'
    end

    self.roles[role.getId()] = role
    return true, 'Role added successfully'
  end

  self.removeRole = function(role)
    local compatibility, errorMessage = self.checkRoleCompatibility(role)
    if not compatibility then
      return false, errorMessage
    end

    if not self.roles[role.getId()] then
      return false, 'Role does not exist'
    end

    self.roles[role.getId()] = nil
    return true, 'Role removed successfully'
  end

  self.getRoleById = function(roleId)
    if not roleId or type(roleId) ~= 'number' then
      return nil, 'Invalid role ID'
    end

    local role = self.roles[roleId]
    if not role then
      return nil, 'Role not found'
    end

    return role, 'Role retrieved successfully'
  end
  

  self.checkMemberCompatibility = function(member)
    if type(member) ~= 'table' then
      return false, 'Member must be a table'
    end

    if not member.__metas or member.__metas.object ~= Config.MagicString.KeyStringMembers then
      return false, 'Invalid member object'
    end

    if member.getSocietyId() ~= self.getId() then
      return false, 'Member does not belong to this society'
    end

    return true, 'Member is compatible with this society'
  end

  self.getMembers = function()
    return self.members
  end

  self.addMember = function(member)
    local compatibility, errorMessage = self.checkMemberCompatibility(member)
    if not compatibility then
      return false, errorMessage
    end

    if self.members[member.getId()] then
      return false, 'Member already exists'
    end

    self.members[member.getId()] = member
    return true, 'Member added successfully'
  end

  self.removeMember = function(member)
    local compatibility, errorMessage = self.checkMemberCompatibility(member)
    if not compatibility then
      return false, errorMessage
    end

    if not self.members[member.getId()] then
      return false, 'Member does not exist'
    end

    self.members[member.getId()] = nil
    return true, 'Member removed successfully'
  end

  self.getMemberByPlayerId = function(playerId)
    for _, member in pairs(self.members) do
      if member.getPlayerId() == playerId then
        return member, nil
      end
    end
    return nil, 'Member not found'
  end

  self.checkPlayerCompatibility = function(player)
    if type(player) ~= 'table' then
      return false, 'Player must be a table'
    end

    if not player.__metas then
      return false, 'Invalid player metas'
    end

    if player.__metas.object ~= Config.MagicString.KeyStringPlayers then
      return false, 'Invalid player object validation'
    end

    local playerId = player.getId()
    if not playerId or type(playerId) ~= 'number' then
      return false, 'Invalid player ID'
    end

    return true, 'Player is compatible with this society'
  end

  self.hirePlayer = function(player)
    local compatibility, errorMessage = self.checkPlayerCompatibility(player)
    if not compatibility then
      return false, errorMessage
    end

    if not self.getRoles() or next(self.getRoles()) == nil then
      return false, 'No roles available in this society'
    end

    local role = nil
    for _, r in pairs(self.getRoles()) do
      if r.getIsDefault() then
        role = r
        break
      end
    end
    if not role then
      return false, 'No default role available in this society'
    end

    -- Check if the player is already a member of this society
    local existingMember, message = self.getMemberByPlayerId(player.getId())
    if existingMember then
      return false, 'Player is already a member of this society'
    end

    local newMember = DuckSocietyMembers()
    newMember.setSociety(self)
    newMember.setRole(role)
    newMember.setPlayer(player)
    Database.maxMemberId = Database.maxMemberId + 1
    newMember.setId(Database.maxMemberId) -- Simple ID generation, could be improved
    
    local success, message = self.addMember(newMember)
    if not success then
      return false, message
    end

    -- If we reach this point, the player is successfully hired
    -- Trigger an event to notify other parts of the system
    print(('Player %d hired in society %s with role %s'):format(player.getId(), self.getName(), role.getName()))

    if player.isOnline() then
      TriggerClientEvent(self.getFullEventName('playerHired'), player.getSource(), player.getId(), self.getId(), role.getId())
    end

    return true, 'Player hired successfully'

  end

  self.firePlayer = function(player)
    local compatibility, errorMessage = self.checkPlayerCompatibility(player)
    if not compatibility then
      return false, errorMessage
    end

    local member, message = self.getMemberByPlayerId(player.getId())
    if not member then
      return false, message
    end

    local success, message = self.removeMember(member)
    if not success then
      return false, message
    end

    -- Trigger an event to notify other parts of the system
    print(('Player %d fired from society %s'):format(player.getId(), self.getName()))

    if player.isOnline() then
      TriggerClientEvent(self.getFullEventName('playerFired'), player.getSource(), player.getId(), self.getId())
    end

    return true, 'Player fired successfully'
  end

  self.serviceCount = function()
    local count = 0
    for _, member in pairs(self.members) do
      if member.getPlayer() ~= nil then
        local player = member.getPlayer()
        if player.isOnline() then
          count = count + 1
        end
      end
    end
    return count
  end

  self.promote = function(player, role, actionner)
    local compatibility, errorMessage = self.checkPlayerCompatibility(player)
    if not compatibility then
      return false, errorMessage
    end

    compatibility, errorMessage = self.checkPlayerCompatibility(actionner)
    if not compatibility then
      return false, errorMessage
    end

    compatibility, errorMessage = self.checkRoleCompatibility(role)
    if not compatibility then
      return false, errorMessage
    end

    local member, message = self.getMemberByPlayerId(player.getId())
    if not member then
      return false, message
    end

    if actionner ~= nil then
      local actionnerMember = self.getMemberByPlayerId(actionner.getId())
      if not actionnerMember then
        return false, 'Actionner is not a member of this society'
      end
      if actionner.getId() == member.getPlayerId() then
        return false, 'You can\'t promote yourself'
      end
      local actionnerMember, actionnerMessage = self.getMemberByPlayerId(actionner.getId())
      if not actionnerMember then
        return false, actionnerMessage
      end
      local promotePermission, promoteMessage = actionnerMember.canPromotePlayer(player, role)
      if not promotePermission then
        return false, promoteMessage
      end
    end

    member.setRole(role)
    print(('Player %d promoted to role %s in society %s'):format(player.getId(), role.getName(), self.getName()))

    if player.isOnline() then
      TriggerClientEvent(self.getFullEventName('playerPromoted'), player.getSource(), player.getId(), self.getId(), role.getId())
    end

    return true, 'Player promoted successfully'
  end

  self.demote = function(player, actionner)
    local compatibility, errorMessage = self.checkPlayerCompatibility(player)
    if not compatibility then
      return false, errorMessage
    end

    compatibility, errorMessage = self.checkPlayerCompatibility(actionner)
    if not compatibility then
      return false, errorMessage
    end

    local member, message = self.getMemberByPlayerId(player.getId())
    if not member then
      return false, message
    end

    if actionner ~= nil then
      local actionnerMember = self.getMemberByPlayerId(actionner.getId())
      if not actionnerMember then
        return false, 'Actionner is not a member of this society'
      end
      if actionner.getId() == member.getPlayerId() then
        return false, 'You can\'t demote yourself'
      end
      local actionnerMember, actionnerMessage = self.getMemberByPlayerId(actionner.getId())
      if not actionnerMember then
        return false, actionnerMessage
      end
      local demotePermission, demoteMessage = actionnerMember.canDemotePlayer(player)
      if not demotePermission then
        return false, demoteMessage
      end
    end

    member.setRole(self.getDefaultRole())
    print(('Player %d demoted in society %s'):format(player.getId(), self.getName()))

    if player.isOnline() then
      TriggerClientEvent(self.getFullEventName('playerDemoted'), player.getSource(), player.getId(), self.getId())
    end

    return true, 'Player demoted successfully'
  end

  return self
end

function LoadSocieties()
  for k,v in pairs(Database.societies) do
    local society = DuckSociety()
    society.loadFromDatabase(v)
    Societies[society.getId()] = society
  end
end

RegisterCommand("getSocietyStatus", function(source, args, rawCommand)
    local societyId = tonumber(args[1])
    if not societyId then
        print("Usage: /getSocietyStatus <societyId>")
        return
    end

    local society = Societies[societyId]
    if not society then
        print("Society with ID " .. societyId .. " not found.")
        return
    end

    print(society.toString())
    print('----- Roles -----')
    for _, role in pairs(society.getRoles()) do
        print(role.toString())
    end
    print('----- Members -----')
    for _, member in pairs(society.getMembers()) do
        print(member.toString())
    end
end, false)

RegisterCommand("editSocietyLabel", function(source, args, rawCommand)
    if source == 0 then
        if #args < 2 then
            print("Usage: editSocietyLabel <societyId> <newLabel>")
            return
        end

        local societyId = tonumber(args[1])
        local newLabel = args[2]
        if not societyId or not newLabel then
            print("Invalid society ID or label.")
            return
        end
        
        local society = Societies[societyId]
        if not society then
            print("Society with ID " .. societyId .. " not found.")
            return
        end

        local exist = false
        for _, s in pairs(Societies) do
            if s.getLabel() == newLabel and s.getId() ~= societyId then
                exist = true
                break
            end
        end

        if exist then
            print("A society with the label '" .. newLabel .. "' already exists.")
            return
        end
        if newLabel == "" then
            print("Label cannot be empty.")
            return
        end

        society.setLabel(newLabel)
        print("Society label updated successfully: " .. society.toString())
    else
        print("This command can only be used from the server console.")
    end
end, false)