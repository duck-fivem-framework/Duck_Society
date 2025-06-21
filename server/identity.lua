function DuckIdentity()
    local self = {}
    self.__metas = { object = Config.MagicString.KeyStringIdentity }

    self.firstname = nil
    self.lastname = nil
    self.dateofbirth = nil

    self = __LoadId(self)

    self.setFirstname = function(firstname) self.firstname = string.lower(firstname) end
    self.getFirstname = function() return self.firstname end
    self.setLastname = function(lastname) self.lastname = string.lower(lastname) end
    self.getLastname = function() return self.lastname end
    self.setDateOfBirth = function(dateofbirth) self.dateofbirth = dateofbirth end
    self.getDateOfBirth = function() return self.dateofbirth end

    self.loadFromDatabase = function(data)
        if data then
            self.setId(data.id)
            self.setFirstname(data.firstname)
            self.setLastname(data.lastname)
            self.setDateOfBirth(data.dateofbirth)
        else
            print("Error: No data provided to load DuckIdentity")
        end
    end

    self.toString = function()
        return string.format("DuckIdentity: { id: %d, firstname: '%s', lastname: '%s', dateofbirth: '%s' }",
            self.getId(), self.getFirstname(), self.getLastname(), self.getDateOfBirth())
    end

    self.getFullName = function()
        return string.format("%s %s", self.getFirstname(), self.getLastname())
    end

    return self
end

function LoadIdentities()
  for k,v in pairs(Database.identities) do
    local identity = DuckIdentity()
    identity.loadFromDatabase(v)
    Identities[identity.getId()] = identity
  end
end

RegisterCommand("editIdentity", function(source, args, rawCommand)
  if source == 0 then
    if #args < 3 then
      print("Usage: editIdentity <id> <firstname> <lastname> <dateOfBirth>")
      return
    end

    local id = tonumber(args[1])
    local firstname = args[2]
    local lastname = args[3]
    local dateOfBirth = args[4] or "01-01-2000" -- Default date if not provided

    if not id or not Identities[id] then
      print("Invalid identity ID.")
      return
    end

    local identity = Identities[id]
    identity.setFirstname(firstname)
    identity.setLastname(lastname)
    identity.setDateOfBirth(dateOfBirth)

    StoreDatabase()
    print("Identity updated successfully.")
  else
    print("This command can only be used from the server console.")
  end
end, false)

RegisterCommand("setPlayerIdentity", function(source, args, rawCommand)
  if source == 0 then
    if #args < 2 then
      print("Usage: setPlayerIdentity <playerId> <identityId>")
      return
    end

    local playerId = tonumber(args[1])
    local identityId = tonumber(args[2])

    if not playerId or not Players[playerId] then
      print("Invalid player ID.")
      return
    end

    if not identityId or not Identities[identityId] then
      print("Invalid identity ID.")
      return
    end

    local player = Players[playerId]
    local identity = Identities[identityId]
    player.setIdentity(identity)
    StoreDatabase()
    print("Player identity updated successfully.")
  else
    print("This command can only be used from the server console.")
  end
end, false)

RegisterCommand("getPlayerIdentity", function(source, args, rawCommand)
  if source == 0 then
    if #args < 1 then
      print("Usage: getPlayerIdentity <playerId>")
      return
    end

    local playerId = tonumber(args[1])

    if not playerId or not Players[playerId] then
      print("Invalid player ID.")
      return
    end

    local player = Players[playerId]
    local identity = player.getIdentity()
    
    if identity then
      print(identity.toString())
    else
      print("Player does not have an identity set.")
    end
  else
    print("This command can only be used from the server console.")
  end
end, false)