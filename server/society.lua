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
      if data.roles and type(data.roles) == 'table' then
        for _, roleData in pairs(data.roles) do
          local role = DuckSocietyRoles()
          role.loadFromDatabase(roleData)
          self.roles[role.getId()] = role
        end
      else
        print("Error: Invalid roles data provided to load DuckSociety")
      end
      if data.members and type(data.members) == 'table' then
        for _, memberData in pairs(data.members) do
          local member = DuckSocietyMembers()
          member.loadFromDatabase(memberData)
          self.members[member.getId()] = member
        end
      else
        print("Error: Invalid members data provided to load DuckSociety")
      end
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

    if not player.__metas or player.__metas.object ~= Config.MagicString.KeyStringPlayer then
      return false, 'Invalid player object'
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

    if player.getSociety() and player.getSociety().getId() == self.getId() then
      return false, 'Player is already a member of this society'
    end

    if not self.roles or next(self.roles) == nil then
      return false, 'No roles available in this society'
    end

    local role = nil
    for _, r in pairs(self.roles) do
      if r.getIsDefault() then
        role = r
        break
      end
    end
    if not role then
      return false, 'No default role available in this society'
    end

    local newMember = DuckSocietyMembers()
    newMember.setSociety(self.getId())
    newMember.setRole(role.getId())
    newMember.setPlayer(player)
    if Config.useDb then
      -- If using database, we need to check if the player is already hired
      local query = [[
        SELECT COUNT(*) as count FROM society_members WHERE society_id = ? AND player_id = ?
      ]]
      local params = { self.getId(), player.getId() }
      local result = MySQL.Sync.fetchScalar(query, params)
      if result and tonumber(result) > 0 then
        return false, 'Player is already hired in this society'
      end
      -- First create in database
      local query = [[
        INSERT INTO society_members (society_id, role_id, player_id)
        VALUES (?, ?, ?)
      ]]
      local params = { self.getId(), role.getId(), player.getId() }
      local result = MySQL.Sync.execute(query, params)
      if result == 0 then
        return false, 'Failed to hire player in database'
      end

      -- need to retrieve the new member ID
      local newMemberId = MySQL.Sync.fetchScalar('SELECT LAST_INSERT_ID()')
      if not newMemberId then
        return false, 'Failed to retrieve new member ID'
      end

      newMember.setId(newMemberId)
    else
      database.maxMemberId = database.maxMemberId + 1
      -- If not using database, we can create the member directly
      newMember.setId(database.maxMemberId) -- Simple ID generation, could be improved

    end
    
    local success, message = self.addMember(newMember)
    if not success then
      return false, message
    end

    -- If we reach this point, the player is successfully hired
    -- Trigger an event to notify other parts of the system
    print(('Player %d hired in society %s with role %s'):format(player.getId(), self.getName(), role.getName()))

    -- Trigger an event to notify the client
    TriggerClientEvent(self.getFullEventName('playerHired'), -1, player.getId(), self.getId(), role.getId())

    return true, 'Player hired successfully'

  end

  self.toString = function()
    return string.format("DuckSociety: { id: %d, name: %s, label: %s, roles: %d, members: %d }",
      self.getId(), self.getName(), self.getLabel(), #self.roles, #self.members)
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

  return self
end